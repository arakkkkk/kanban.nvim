local M = {}

function M.init()
  return {
    selection = {
      list_int = 1,
      task_int = 1,
      task_cursor_pos_int = 1,
    },
    max_task_show_int = 0,
  }
end

return M
