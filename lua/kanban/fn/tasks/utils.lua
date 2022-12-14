local M = {}
M.utils = {}

-- function M.get_by_bufnr(kanban, bufnr)
-- 	for i in pairs(kanban.items.lists) do
-- 		local list = kanban.items.lists[i]
-- 		for j in pairs(list.tasks) do
-- 			local task = list.tasks[j]
-- 			if bufnr == task.buf_nr then
-- 				return task
-- 			end
-- 		end
-- 	end
-- end

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
	local contents = { task.title }
	for i in pairs(task.due) do
		table.insert(contents, task.due[i])
	end
	for i in pairs(task.tag) do
		table.insert(contents, task.tag[i])
	end
	return contents
end

function M.get_max_task_show_int(kanban)
	local list_heihgt = kanban.items.lists[1].buf_conf.height
	local task_area_height = list_heihgt - 4 - 2
	local task_height = kanban.ops.layout.task_height + kanban.ops.layout.task_y_margin
	local show_task_height = task_area_height / task_height
	return show_task_height + 1
end

function M.count_due(line)
	local t = os.date("*t")
	local y = string.gsub(line, "^@(%d%d%d%d)/%d%d/%d%d$", "%1")
	local m = string.gsub(line, "^@%d%d%d%d/(%d%d)/%d%d$", "%1")
	local d = string.gsub(line, "^@%d%d%d%d/%d%d/(%d%d)$", "%1")
	local due_time = os.time({ year = y, month = m, day = d, hour = 0, min = 0, sec = 0 })
	local due_days = due_time / (60 * 60 * 24)
	local now_time = os.time() - t.hour * 3600 - t.min * 60 - t.sec
	local now_days = now_time / (60 * 60 * 24)
	return due_days - now_days
end

function M.count_visible_tasks_in_list(kanban, list_num)
	local list = kanban.items.lists[list_num]
	local res_count = 0
	for _, task in pairs(list.tasks) do
		if kanban.fn.tasks.filter.is_visible(kanban, task) then
			res_count = res_count + 1
		end
	end
	return res_count
end

return M
