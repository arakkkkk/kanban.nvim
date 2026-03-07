-- blink.cmp integration for kanban.nvim
--
-- 目的:
-- - `kanban` ファイルタイプで `@` 期限トークンと `#` タグの補完を提供
-- - blink.cmp のソース仕様（Source Boilerplate）に沿った provider 実装
--   ref: https://cmp.saghen.dev/development/source-boilerplate

local M = {}

-- ===== 内部ユーティリティ =====

local cmp_common = require('kanban.fn.cmp.common')

local cmp_types = (function()
  local ok, types = pcall(require, 'blink.cmp.types')
  if ok and types and types.CompletionItemKind then
    return types.CompletionItemKind
  end
  return { Text = 1 }
end)()

local function due_candidates(prefix)
  local docs = {
    direct = { kind = 'plaintext', value = '入力済みトークンを日付へ展開' },
    preset = { kind = 'plaintext', value = '期日トークンを日付へ展開' },
  }

  return cmp_common.map_due_matches(prefix, function(match)
    return {
      label = match.token .. ' → ' .. match.expanded,
      insertText = match.expanded,
      filterText = match.token,
      kind = cmp_types.Text,
      documentation = match.is_direct and docs.direct or docs.preset,
    }
  end)
end

local function tag_candidates(kanban, prefix)
  return cmp_common.map_tag_matches(kanban, prefix, function(tag)
    return {
      label = '#' .. tag,
      insertText = '#' .. tag,
      filterText = '#' .. tag,
      kind = cmp_types.Text,
      documentation = { kind = 'plaintext', value = '既存タグから補完' },
    }
  end)
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

