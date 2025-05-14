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
		lines = {},
		check = false,
	}
	return blank_task
end

function M.create_window_text(kanban, task)
	local contents = {}
	for i in pairs(task.lines) do
		table.insert(contents, task.lines[i])
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
	local y = string.match(line, "^@(%d%d%d%d).%d%d.%d%d$") or 9999
	local m = string.match(line, "^@%d%d%d%d.(%d%d).%d%d$") or 12
	local d = string.match(line, "^@%d%d%d%d.%d%d.(%d%d)$") or 31
	local due_time = os.time({ year = y, month = m, day = d, hour = 0, min = 0, sec = 0 })
	local due_days = due_time / (60 * 60 * 24)
	local now_time = os.time() - t.hour * 3600 - t.min * 60 - t.sec
	local now_days = now_time / (60 * 60 * 24)
	return due_days - now_days
end

return M
