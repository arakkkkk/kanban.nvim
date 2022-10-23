local M = {}
function M.resize(kanban)
	for i in pairs(kanban.items.lists) do
		local list = kanban.items.lists[i]
		for j in pairs(list.tasks) do
			local task = list.tasks[j]
			if task.win_id ~= nil then
	  		task.buf_conf.row = (list.buf_conf.row + 4) + (kanban.ops.layout.task_height + 2)*(j-1)
	  		task.buf_conf.col = list.buf_conf.col + 2
	  		task.buf_conf.width = list.buf_conf.width - 4
	  		vim.api.nvim_win_set_config(task.win_id, task.buf_conf)
	  	end
		end
	end
end
return M
