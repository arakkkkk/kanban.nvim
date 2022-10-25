local M = {}

local function animation(kanban, task, start_row, start_col, end_row, end_col)
	local fps = 10
	local speed = 0.1
	local row_diff = 0
	local col_diff = 0
	if start_row ~= end_row then
		row_diff = (start_row - end_row) / fps
	end
	if start_col ~= end_col then
		col_diff = (start_col - end_col) / fps
	end

	if kanban.ops.animation then
		for _ = 1, fps do
			-- for _ = 1, 3 do
			task.buf_conf.row = task.buf_conf.row - row_diff
			task.buf_conf.col = task.buf_conf.col - col_diff
			-- os.execute("sleep " .. tonumber(speed / fps))
			-- os.execute("sleep " .. 0.01)
			vim.api.nvim_win_set_config(task.win_id, task.buf_conf)
		end
	else
		task.buf_conf.row = end_row
		task.buf_conf.col = end_col
	end
end

function M.resize(kanban, list_int)
	-- list_int: A number of resize list, 0 is all list
	for i in pairs(kanban.items.lists) do
		local list = kanban.items.lists[i]
		local task_show_count = 0
		for j in pairs(list.tasks) do
			local task = list.tasks[j]
			if task.win_id ~= nil then
				task.buf_conf.width = list.buf_conf.width - 4
				local end_row = (list.buf_conf.row + 4) + (kanban.ops.layout.task_height + 2) * task_show_count
				local end_col = list.buf_conf.col + 2
				-- animation(kanban, task, task.buf_conf.row, task.buf_conf.col, end_row, end_col)
				task.buf_conf.row = end_row
				task.buf_conf.col = end_col
				vim.api.nvim_win_set_config(task.win_id, task.buf_conf)
				task_show_count = task_show_count + 1
			end
		end
	end
end
return M
