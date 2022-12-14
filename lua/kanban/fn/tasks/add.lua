local M = {}
-- Absolute path
function M.add(kanban, list_num, task, add_position)
	local target_list
	if list_num == nil then
		local focus = kanban.fn.tasks.utils.get_focus(kanban)
		target_list = kanban.items.lists[focus.list_num]
	else
		target_list = kanban.items.lists[list_num]
	end

	-- Create new task by template (option.markdown)
	local is_empty_task = false
	if task == nil then
		is_empty_task = true
		task = kanban.fn.tasks.utils.create_blank_task(kanban)
	end

	task.buf_conf = {
		relative = "editor",
		row = 10,
		col = 10,
		width = target_list.buf_conf.width - 4,
		height = kanban.ops.layout.task_height,
		border = "rounded",
		style = "minimal",
		zindex = 30,
	}

	task.buf_nr = nil
	task.win_id = nil

	local tasks = target_list.tasks
	if add_position == "top" then
		table.insert(tasks, 1, task)
	elseif add_position == "bottom" then
		table.insert(tasks, #tasks + 1, task)
	else
		assert(false)
	end

	local max_task_show_int = kanban.fn.tasks.utils.get_max_task_show_int(kanban)
	if not kanban.fn.tasks.filter.is_visible(kanban, task) then
		return task
	elseif kanban.fn.tasks.utils.count_visible_tasks_in_list(kanban, list_num) > max_task_show_int then
		return task
	end

	kanban.fn.tasks.open(kanban, task)
	vim.fn.win_gotoid(task.win_id)

	return task
end
return M
