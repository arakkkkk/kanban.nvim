local M = {}
-- Absolute path
function M.add(kanban, list_num, task, add_position, open_bool)
	local target_list
	if list_num == nil then
		local focus = kanban.fn.tasks.utils.get_focus(kanban)
		target_list = kanban.items.lists[focus.list_num]
	else
		target_list = kanban.items.lists[list_num]
	end

	-- Create new task by template (option.markdown)
	if task == nil then
		task = kanban.fn.tasks.utils.create_blank_task(kanban)
	end

	local tasks = target_list.tasks
	local border
	if task.check then
		border = kanban.ops.layout.complete_border
	else
		border = kanban.ops.layout.uncomplete_border
	end

	task.buf_conf = {
		relative = "editor",
		row = 10,
		col = 10,
		width = target_list.buf_conf.width - 4,
		height = kanban.ops.layout.task_height,
		border = border,
		style = "minimal",
		zindex = 30,
	}

	task.buf_nr = nil
	task.win_id = nil

	if add_position == "top" then
		table.insert(tasks, 1, task)
	elseif add_position == "bottom" then
		table.insert(tasks, #tasks + 1, task)
	else
		assert(false)
	end

	if not open_bool then
		return
	end
	kanban.fn.tasks.open(kanban, task)
	vim.fn.win_gotoid(task.win_id)

	if add_position == "top" then
		kanban.fn.tasks.move.top(kanban)
	elseif add_position == "bottom" then
		kanban.fn.tasks.move.bottom(kanban)
	end
	return task
end
return M
