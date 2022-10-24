local M = {}

function M.move_top(kanban, task)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
  local focused_list = kanban.items.lists[focus.list_num]
  local focused_tasks = focused_list.tasks
  local top_task = focused_tasks[1]
	vim.fn.win_gotoid(top_task)
end

return M
