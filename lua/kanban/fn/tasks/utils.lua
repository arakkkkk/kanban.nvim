local M = {}
M.utils = {}

function M.get_focus(kanban)
	for i in pairs(kanban.items.lists) do
		local list = kanban.items.lists[i]
		for j in pairs(list.tasks) do
			local task = list.tasks[j]
			if vim.fn.win_getid() == task.win_id then
				return { list_num = i, task_num = j }
			end
		end
	end
	assert(false)
end

function M.create_blank_task(kanban)
	local blank_task = {
		title = "",
		due = {},
		tag = {},
	}
	return blank_task
end

function M.create_window_text(task)
	local contents = {task.title}
	for i in pairs(task.due) do
		table.insert(contents, task.due[i])
	end
	for i in pairs(task.tag) do
		table.insert(contents, task.tag[i])
	end
	return contents
end

return M
