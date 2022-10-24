local M = {}
-- Absolute path
function M.add(kanban, list_num, task, add_position)
	assert(add_position == "top" or add_position == "bottom")
	local target_list = kanban.items.lists[list_num]

	local tasks = target_list.tasks
	tasks[#tasks + 1] = task
	tasks[#tasks].buf_conf = {
		relative = "editor",
		row = 10,
		col = 10,
		width = target_list.buf_conf.width - 4,
		height = kanban.ops.layout.task_height,
		border = "rounded",
		style = "minimal",
		zindex = 50,
	}

	tasks[#tasks].buf_nr = nil
	tasks[#tasks].win_id = nil
end
return M
