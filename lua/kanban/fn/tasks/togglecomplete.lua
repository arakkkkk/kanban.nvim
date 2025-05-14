local M = {}
-- Absolute path
function M.togglecomplete(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	local focused_tasks = focused_list.tasks
	local focused_task = focused_tasks[focus.task_num]

	if focused_task.check then
		focused_task.check = false
		focused_task.buf_conf.border = kanban.ops.layout.uncomplete_border
	else
		focused_task.check = true
		focused_task.buf_conf.border = kanban.ops.layout.complete_border
	end

	vim.api.nvim_win_set_config(focused_task.win_id, focused_task.buf_conf)
end

return M
