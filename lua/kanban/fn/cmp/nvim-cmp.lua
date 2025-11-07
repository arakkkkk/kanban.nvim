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

local cmp_common = require('kanban.fn.cmp.common')

local function due_candidates(prefix)
  return cmp_common.map_due_matches(prefix, function(match)
    local documentation
    if match.is_direct then
      documentation = '入力済みトークンを日付へ展開'
    else
      documentation = '期日トークンを日付へ展開して挿入します'
    end
    return {
      label = match.token .. ' → ' .. match.expanded,
      insertText = match.expanded,
      filterText = match.token,
      kind = 21, -- Text
      documentation = documentation,
    }
  end)
end

local function tag_candidates(kanban, prefix)
  return cmp_common.map_tag_matches(kanban, prefix, function(tag)
    return {
      label = '#' .. tag,
      insertText = '#' .. tag,
      filterText = '#' .. tag,
      kind = 1, -- Text
      documentation = '既存タグから補完',
    }
  end)
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
