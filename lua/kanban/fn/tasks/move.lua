local M = {}

function M.top(kanban)
	kanban.fn.tasks.save(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	local focused_tasks = focused_list.tasks
	-- close all task window
	for i in pairs(focused_tasks) do
		local task = focused_tasks[i]
		if task.win_id ~= nil then
			kanban.fn.tasks.close(task)
		end
	end
	-- reopen task window
	local max_task_show_int = kanban.fn.tasks.utils.get_max_task_show_int(kanban)
	for i in pairs(focused_tasks) do
		if i >= max_task_show_int then
			break
		end
		local open_task_index = i
		kanban.fn.tasks.open(kanban, focused_tasks[open_task_index])
	end
	-- focus top task
	vim.fn.win_gotoid(focused_tasks[1].win_id)
end

function M.bottom(kanban)
	kanban.fn.tasks.save(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	local focused_tasks = focused_list.tasks
	-- close all task window
	for i in pairs(focused_tasks) do
		local task = focused_tasks[i]
		if task.win_id ~= nil then
			kanban.fn.tasks.close(task)
		end
	end
	-- reopen task window
	local max_task_show_int = kanban.fn.tasks.utils.get_max_task_show_int(kanban)
	for i in pairs(focused_tasks) do
		if i >= max_task_show_int then
			break
		end
		local open_task_index = #focused_tasks - i + 1
		kanban.fn.tasks.open(kanban, focused_tasks[open_task_index])
	end
	-- focus top task
	vim.fn.win_gotoid(focused_tasks[#focused_tasks].win_id)
end

function M.up(kanban)
	kanban.fn.tasks.save(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	local focused_task = focused_list.tasks[focus.task_num]
	for i in pairs(kanban.items.lists) do
		local list = kanban.items.lists[i]
		for j in pairs(list.tasks) do
			if list.tasks[j].win_id == focused_task.win_id then
				local above_task = list.tasks[j - 1]
				-- Up without scroll
				if j > 1 and above_task.win_id ~= nil then
					vim.fn.win_gotoid(above_task.win_id)
				-- Up with scroll
				elseif j > 1 and above_task.win_id == nil then
					-- Close foot task window (above nil window)
					for k = j, #list.tasks do
						if list.tasks[k].win_id == nil or k == #list.tasks then
							kanban.fn.tasks.close(list.tasks[k - 1])
							break
						end
					end
					-- Open bellow task window
					kanban.fn.tasks.open(kanban, above_task)
					vim.fn.win_gotoid(above_task.win_id)
				end
				break
			end
		end
	end
end

function M.down(kanban)
	kanban.fn.tasks.save(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	local focused_task = focused_list.tasks[focus.task_num]
	for i in pairs(kanban.items.lists) do
		local list = kanban.items.lists[i]
		for j in pairs(list.tasks) do
			if list.tasks[j].win_id == focused_task.win_id then
				local below_task = list.tasks[j + 1]
				-- Up without scroll
				if j < #list.tasks and below_task.win_id ~= nil then
					vim.fn.win_gotoid(below_task.win_id)
				-- Up with scroll
				elseif j < #list.tasks and below_task.win_id == nil then
					-- Close head task window
					for k in pairs(list.tasks) do
						if list.tasks[k].win_id ~= nil then
							kanban.fn.tasks.close(list.tasks[k])
							break
						end
					end
					-- Open bellow task window
					kanban.fn.tasks.open(kanban, below_task)
					vim.fn.win_gotoid(below_task.win_id)
				end
				break
			end
		end
	end
end

function M.left(kanban)
	kanban.fn.tasks.save(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	local focused_task = focused_list.tasks[focus.task_num]
	local selected_row_int
	for i in pairs(kanban.items.lists) do
		local list = kanban.items.lists[i]
		local prev_list = kanban.items.lists[i - 1]
		selected_row_int = 0
		for j in pairs(list.tasks) do
			if list.tasks[j].win_id ~= nil then
				selected_row_int = selected_row_int + 1
			end
			if list.tasks[j].win_id == focused_task.win_id then
				if i > 1 then
					local notnil_count = 0
					for k in pairs(prev_list.tasks) do
						if prev_list.tasks[k].win_id ~= nil then
							notnil_count = notnil_count + 1
							if notnil_count == selected_row_int or k == prev_list.tasks then
								vim.fn.win_gotoid(prev_list.tasks[k].win_id)
								break
							end
						end
						vim.fn.win_gotoid(prev_list.tasks[#prev_list.tasks].win_id)
					end
				end
			end
		end
	end
	return selected_row_int
end

function M.right(kanban)
	kanban.fn.tasks.save(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	local focused_task = focused_list.tasks[focus.task_num]
	local selected_row_int
	for i in pairs(kanban.items.lists) do
		local list = kanban.items.lists[i]
		local next_list = kanban.items.lists[i + 1]
		selected_row_int = 0
		for j in pairs(list.tasks) do
			if list.tasks[j].win_id ~= nil then
				selected_row_int = selected_row_int + 1
			end
			if list.tasks[j].win_id == focused_task.win_id then
				if i < #kanban.items.lists then
					local notnil_count = 0
					for k in pairs(next_list.tasks) do
						if next_list.tasks[k].win_id ~= nil then
							notnil_count = notnil_count + 1
							if notnil_count == selected_row_int or k == next_list.tasks then
								vim.fn.win_gotoid(next_list.tasks[k].win_id)
								break
							end
						end
						vim.fn.win_gotoid(next_list.tasks[#next_list.tasks].win_id)
					end
				end
			end
		end
	end
	return selected_row_int
end

return M
