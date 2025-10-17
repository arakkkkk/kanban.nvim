-- blink.cmp integration for kanban.nvim
--
-- 目的:
-- - `kanban` ファイルタイプで `@` 期限トークンと `#` タグの補完を提供
-- - blink.cmp のソース仕様（Source Boilerplate）に沿った provider 実装
--   ref: https://cmp.saghen.dev/development/source-boilerplate

local M = {}

-- ===== 内部ユーティリティ =====

local function uniq(list)
  local seen, out = {}, {}
  for _, v in ipairs(list) do
    if v and v ~= '' and not seen[v] then
      seen[v] = true
      table.insert(out, v)
    end
  end
  return out
end

local function format_date(t)
  return os.date('@%Y/%m/%d', t)
end

-- `@today`, `@2d`, `@1w`, `@2m`, `@1y`, `@mo`..`@su`, `@/MM/DD`, `@//DD`
local function expand_due_token(tok)
  if not tok or tok:sub(1, 1) ~= '@' then return nil end

  if tok == '@today' or tok == '@tod' or tok == '@to' then
    return format_date(os.time())
  end

  local d = tok:match('^@(%d+)d$')
  if d then return format_date(os.time() + (tonumber(d) * 24 * 60 * 60)) end

  local w = tok:match('^@(%d+)w$')
  if w then return format_date(os.time() + (tonumber(w) * 7 * 24 * 60 * 60)) end

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

  local y = tok:match('^@(%d+)y$')
  if y then
    local t = os.date('*t')
    t.year = t.year + tonumber(y)
    return string.format('@%04d/%02d/%02d', t.year, t.month, t.day)
  end

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

  do
    local n_part, wd = tok:match('^@(n*)([a-z][a-z])$')
    if wd then
      local step_week_num = #n_part
      local base = os.time()
      local today = os.date('*t')
      local sunday = base - ((today.wday - 1) * 24 * 60 * 60)
      local target = sunday + (step_week_num * 7 * 24 * 60 * 60)
      local map = { su = 0, mo = 1, tu = 2, we = 3, th = 4, fr = 5, sa = 6 }
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
          kind = require('blink.cmp.types').CompletionItemKind.Text,
          documentation = { kind = 'plaintext', value = '期日トークンを日付へ展開' },
        })
      end
    end
  end
  local direct = expand_due_token(prefix)
  if direct then
    table.insert(items, 1, {
      label = prefix .. ' → ' .. direct,
      insertText = direct,
      filterText = prefix,
      kind = require('blink.cmp.types').CompletionItemKind.Text,
      documentation = { kind = 'plaintext', value = '入力済みトークンを日付へ展開' },
    })
  end
  local seen, out = {}, {}
  for _, it in ipairs(items) do
    local key = it.insertText or it.label
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
            if type(t) == 'string' and t ~= '' then table.insert(tags, t) end
          end
        end
      end
    end
  end
  return uniq(tags)
end

local function tag_candidates(kanban, prefix)
  local p = prefix:sub(2):lower()
  local items = {}
  for _, tag in ipairs(collect_tags(kanban)) do
    local tl = string.lower(tag)
    if tl:sub(1, #p) == p then
      table.insert(items, {
        label = '#' .. tag,
        insertText = '#' .. tag,
        filterText = '#' .. tag,
        kind = require('blink.cmp.types').CompletionItemKind.Text,
        documentation = { kind = 'plaintext', value = '既存タグから補完' },
      })
    end
  end
  return items
end

-- 検索対象トークンと置換範囲を取得
local function extract_token_and_range(ctx)
  local bufnr = ctx.bufnr
  local cur = ctx.cursor or {}
  local line0 = cur.line or cur[1] or 0 -- 0-indexed line
  local col0 = cur.character or cur[2] or 0 -- 0-indexed col
  local line = (vim.api.nvim_buf_get_lines(bufnr, line0, line0 + 1, true)[1] or '')

  -- 1-indexed string ops
  local before = line:sub(1, col0)
  local token = before:match('([#@][^%s]*)$')
  if not token then return nil end
  local start_byte_1 = #before - #token + 1 -- 1-indexed start
  local range = {
    start = { line = line0, character = start_byte_1 - 1 },
    ['end'] = { line = line0, character = col0 },
  }
  return token, range
end

-- ===== ソース本体 =====

--- @class blink.cmp.Source
local source = {}

--- opts は sources.providers.kanban.opts から渡される
function source.new(opts)
  local self = setmetatable({}, { __index = source })
  self.opts = opts or {}
  -- kanban 本体を遅延取得（起動順依存を避ける）
  self.get_kanban = function()
    local ok, k = pcall(require, 'kanban')
    if ok then return k end
    return nil
  end
  return self
end

function source:enabled()
  return vim.bo.filetype == 'kanban'
end

function source:get_trigger_characters()
  return { '@', '#' }
end

function source:get_completions(ctx, callback)
  local token, range = extract_token_and_range(ctx)
  if not token then
    callback({ items = {}, is_incomplete_backward = false, is_incomplete_forward = false })
    return
  end

  local items
  if token:sub(1, 1) == '@' then
    items = due_candidates(token)
  else
    local kanban = self.get_kanban()
    items = tag_candidates(kanban, token)
  end

  -- textEdit の範囲を付与
  for _, it in ipairs(items) do
    local newText = it.insertText or it.label
    it.textEdit = {
      newText = newText,
      range = range,
    }
    it.insertText = nil -- textEdit を優先
  end

  callback({
    items = items,
    is_incomplete_backward = false,
    is_incomplete_forward = false,
  })
end

return source

