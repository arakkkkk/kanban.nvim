local M = {}

function M.resize(kanban, list_int)
	-- list_int: A number of resize list, 0 is all list
	for i in pairs(kanban.items.lists) do
		local list = kanban.items.lists[i]
		local task_show_count = 0
		for j in pairs(list.tasks) do
			local task = list.tasks[j]
			if task.win_id ~= nil then
				local end_row = (list.buf_conf.row + 4) + (kanban.ops.layout.task_height + 2) * task_show_count
				local end_col = list.buf_conf.col + 2
				task.buf_conf.width = list.buf_conf.width - 4
				task.buf_conf.row = end_row
				task.buf_conf.col = end_col
				vim.api.nvim_win_set_config(task.win_id, task.buf_conf)
				task_show_count = task_show_count + 1
			end
		end
	end
end
return M
