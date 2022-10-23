local M = {}

function M.move()
  local task_int = M.state.selection.task_int
  local task_cursor_pos_int =  M.state.selection.task_cursor_pos_int
  vim.api.win_gotoid()
end

return M
