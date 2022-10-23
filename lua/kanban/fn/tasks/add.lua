local M = {}
-- Absolute path
function M.add(kanban, list_title, task)
	local target_list
	for i in pairs(kanban.items.lists) do
		local list = kanban.items.lists[i]
		if list.title == list_title then
			target_list = list
			break
		end
	end

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
