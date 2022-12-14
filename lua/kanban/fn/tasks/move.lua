local M = {}

function M.top(kanban)
	kanban.fn.tasks.save(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	local focused_tasks = focused_list.tasks
	-- close all task window
	for i in pairs(focused_tasks) do
		local task = focused_tasks[i]
		if task.win_id ~= nil and kanban.fn.tasks.filter.is_visible(kanban, task) then
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
		if kanban.fn.tasks.filter.is_visible(kanban, focused_tasks[open_task_index]) then
			kanban.fn.tasks.open(kanban, focused_tasks[open_task_index])
		end
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
		if task.win_id ~= nil and kanban.fn.tasks.filter.is_visible(kanban, task) then
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
		if kanban.fn.tasks.filter.is_visible(kanban, focused_tasks[open_task_index]) then
			kanban.fn.tasks.open(kanban, focused_tasks[open_task_index])
		end
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
		if i == focus.list_num then
			local list = kanban.items.lists[i]
			for j = focus.task_num -1, 1, -1 do
				local above_task = list.tasks[j]
				-- Up without scroll
				if above_task.win_id ~= nil and kanban.fn.tasks.filter.is_visible(kanban, above_task) then
					vim.fn.win_gotoid(above_task.win_id)
					return
				-- Up with scroll
				elseif above_task.win_id == nil and kanban.fn.tasks.filter.is_visible(kanban, above_task) then
					-- Close foot task window (above nil window)
					for k = #list.tasks, 1, -1 do
						if list.tasks[k].win_id ~= nil then
							kanban.fn.tasks.close(list.tasks[k])
							break
						end
					end
					-- Open bellow task window
					kanban.fn.tasks.open(kanban, above_task)
					vim.fn.win_gotoid(above_task.win_id)
					return
				end
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
		if i == focus.list_num then
			local list = kanban.items.lists[i]
			for j = focus.task_num + 1, #focused_list.tasks do
				local bellow_task = list.tasks[j]
				-- Up without scroll
				if bellow_task.win_id ~= nil and kanban.fn.tasks.filter.is_visible(kanban, bellow_task) then
					vim.fn.win_gotoid(bellow_task.win_id)
					return
				-- Up with scroll
				elseif bellow_task.win_id == nil and kanban.fn.tasks.filter.is_visible(kanban, bellow_task) then
					-- Close foot task window (above nil window)
					for k = 1, #focused_list.tasks do
						if list.tasks[k].win_id ~= nil then
							kanban.fn.tasks.close(list.tasks[k])
							break
						end
					end
					-- Open bellow task window
					kanban.fn.tasks.open(kanban, bellow_task)
					vim.fn.win_gotoid(bellow_task.win_id)
					return
				end
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
