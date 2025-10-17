-- nvim-cmp integration for kanban.nvim
--
-- 目的:
-- - `kanban`ファイルタイプのバッファで、`@` 期限入力や `#` タグ入力を補完する
-- - 依存: hrsh7th/nvim-cmp（未インストール時は何もしない安全実装）
--
-- 提供関数:
-- - `setup(kanban)`
--     - cmp が利用可能ならカスタムソース `kanban` を登録し、filetype=kanban で有効化
-- - `is_available()`
--     - nvim-cmp がロード可能かを返す
--
-- 実装方針:
-- - 直近トークン `([#@][^%s]*)$` を検出し、`@` は期日候補、`#` は既存タスクのタグ候補を返す
-- - 期日候補はトークンを実日付へ展開（@today, @2d, @1w, @1m, @1y, @mo..@su など）
-- - タグ候補は現在の kanban データからユニークに抽出して前方一致で提示

local M = {}
-- 多重登録防止用のモジュール内状態
local source_instance = nil
local registered = false
local ft_configured = false

-- ===== 内部: ユーティリティ =====

local function p_require(name)
  local ok, mod = pcall(require, name)
  if ok then return mod end
  return nil
end

local function uniq(list)
  local seen, out = {}, {}
  for _, v in ipairs(list) do
    if v ~= nil and v ~= '' and not seen[v] then
      seen[v] = true
      table.insert(out, v)
    end
  end
  return out
end

-- YYYY/MM/DD へ展開
local function format_date(t)
  return os.date("@%Y/%m/%d", t)
end

-- `@today`, `@2d`, `@1w`, `@2m`, `@1y`, `@mo`..`@su` を実日付に展開
local function expand_due_token(tok)
  if not tok or tok:sub(1,1) ~= '@' then return nil end

  -- today
  if tok == '@today' or tok == '@tod' or tok == '@to' then
    return format_date(os.time())
  end

  -- Nx: days/weeks/months/years
  do
    local d = tok:match('^@(%d+)d$')
    if d then
      local sec = os.time() + (tonumber(d) * 24 * 60 * 60)
      return format_date(sec)
    end
  end
  do
    local w = tok:match('^@(%d+)w$')
    if w then
      local sec = os.time() + (tonumber(w) * 7 * 24 * 60 * 60)
      return format_date(sec)
    end
  end
  do
    local m = tok:match('^@(%d+)m$')
    if m then
      local t = os.date('*t')
      for _ = 1, tonumber(m) do
        if t.month == 12 then
          t.year = t.year + 1
          t.month = 1
        else
          t.month = t.month + 1
        end
      end
      return string.format('@%04d/%02d/%02d', t.year, t.month, t.day)
    end
  end
  do
    local y = tok:match('^@(%d+)y$')
    if y then
      local t = os.date('*t')
      t.year = t.year + tonumber(y)
      return string.format('@%04d/%02d/%02d', t.year, t.month, t.day)
    end
  end

  -- @/MM/DD or //@DD
  do
    local mm, dd = tok:match('^@/(%d%d)/(%d%d)$')
    if mm and dd then
      local t = os.date('*t')
      return string.format('@%04d/%s/%s', t.year, mm, dd)
    end
  end
  do
    local dd = tok:match('^@//(%d%d)$')
    if dd then
      local t = os.date('*t')
      return string.format('@%04d/%02d/%s', t.year, t.month, dd)
    end
  end

  -- week day: @su..@sa または n を重ねて翌週以降
  do
    local n_part, wd = tok:match('^@(n*)([a-z][a-z])$')
    if wd then
      local step_week_num = #n_part
      local base = os.time()
      local today = os.date('*t')
      -- Lua: Sunday=1 ... Saturday=7
      local sunday = base - ((today.wday - 1) * 24 * 60 * 60)
      local target = sunday + (step_week_num * 7 * 24 * 60 * 60)
      local map = { su=0, mo=1, tu=2, we=3, th=4, fr=5, sa=6 }
      local offset = map[wd]
      if offset ~= nil then
        target = target + (offset * 24 * 60 * 60)
        return format_date(target)
      end
    end
  end

  return nil
end

local function due_candidates(prefix)
  -- 代表的トークン候補。前方一致で提示し、`insertText` は展開後の日付にする
  local tokens = {
    '@today', '@1d', '@2d', '@3d', '@5d', '@7d',
    '@1w', '@2w', '@3w',
    '@1m', '@2m', '@3m',
    '@1y', '@2y',
    '@su', '@mo', '@tu', '@we', '@th', '@fr', '@sa',
    '@nmo', '@ntu', '@nwe', '@nth', '@nfr', '@nsa', '@nsu',
  }
  local items = {}
  for _, tok in ipairs(tokens) do
    if tok:sub(1, #prefix) == prefix then
      local expanded = expand_due_token(tok)
      if expanded then
        table.insert(items, {
          label = tok .. ' → ' .. expanded,
          insertText = expanded,
          filterText = tok,
          kind = 21, -- Text
          documentation = '期日トークンを日付へ展開して挿入します',
        })
      end
    end
  end
  -- プレフィクス自体が完全トークンなら、直接展開候補も追加
  local direct = expand_due_token(prefix)
  if direct then
    table.insert(items, 1, {
      label = prefix .. ' → ' .. direct,
      insertText = direct,
      filterText = prefix,
      kind = 21,
      documentation = '入力済みトークンを日付へ展開',
    })
  end
  -- 重複排除（同じ展開候補が複数回並ばないように）
  local seen, out = {}, {}
  for _, it in ipairs(items) do
    local key = (it.insertText or it.label)
    if not seen[key] then
      seen[key] = true
      table.insert(out, it)
    end
  end
  return out
end

local function collect_tags(kanban)
  local tags = {}
  if not kanban or not kanban.items or not kanban.items.lists then return tags end
  for _, list in ipairs(kanban.items.lists) do
    if list and list.tasks then
      for _, task in ipairs(list.tasks) do
        if task and type(task.tag) == 'table' then
          for _, t in ipairs(task.tag) do
            if type(t) == 'string' and t ~= '' then
              table.insert(tags, t)
            end
          end
        end
      end
    end
  end
  return uniq(tags)
end

local function tag_candidates(kanban, prefix)
  local p = prefix:sub(2):lower() -- remove '#'
  local items = {}
  for _, tag in ipairs(collect_tags(kanban)) do
    local tl = string.lower(tag)
    if tl:sub(1, #p) == p then
      table.insert(items, {
        label = '#' .. tag,
        insertText = '#' .. tag,
        filterText = '#' .. tag,
        kind = 1, -- Text
        documentation = '既存タグから補完',
      })
    end
  end
  return items
end

-- ===== cmp ソース =====

local function build_source(kanban)
  local source = {}

  function source.new()
    return setmetatable({ kanban = kanban }, { __index = source })
  end

  function source:is_available()
    return true
  end

  function source:get_debug_name()
    return 'kanban'
  end

  function source:complete(params, callback)
    local line = params.context.cursor_before_line or ''
    local word = line:match('([#@][^%s]*)$')
    if not word then
      callback({})
      return
    end

    if word:sub(1,1) == '@' then
      callback(due_candidates(word))
      return
    end
    if word:sub(1,1) == '#' then
      callback(tag_candidates(self.kanban, word))
      return
    end
    callback({})
  end

  return source
end

-- ===== 公開関数 =====

function M.is_available()
  return p_require('cmp') ~= nil
end

function M.setup(kanban)
  local cmp = p_require('cmp')
  if not cmp then
    return false, 'nvim-cmp が見つかりません'
  end

  if not registered then
    source_instance = build_source(kanban).new()
    local ok_reg, err = pcall(function()
      cmp.register_source('kanban', source_instance)
    end)
    if not ok_reg then
      return false, ('ソース登録に失敗: %s'):format(err)
    end
    registered = true
  else
    -- 既に登録済みなら、最新の kanban 参照だけ更新
    if source_instance then
      source_instance.kanban = kanban
    end
  end

  if not ft_configured then
    -- filetype=kanban のときだけこのソースを有効化
    cmp.setup.filetype('kanban', {
      sources = cmp.config.sources({
        { name = 'kanban' },
      }, {
        { name = 'buffer' },
        { name = 'path' },
      }),
    })
    ft_configured = true
  end

  return true
end

return M
