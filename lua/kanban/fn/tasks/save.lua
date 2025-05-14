local M = {}
function M.save(kanban)
	-- up date kanban object on active task
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	local task = focused_list.tasks[focus.task_num]
	local lines = vim.fn.getbufline(task.buf_nr, 1, "$")

	task.lines = lines
end
return M
