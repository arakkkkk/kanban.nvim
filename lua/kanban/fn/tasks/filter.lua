local M = {}
function M.filter(kanban)
	for i, list in pairs(kanban.items.lists) do
		local show_count = 0
		for _, task in pairs(list.tasks) do
			local max_task_show_int = kanban.fn.tasks.utils.get_max_task_show_int(kanban)
			if show_count > max_task_show_int then
				if task.win_id ~= nil then
					kanban.fn.tasks.close(task)
				end
			else
				if not kanban.fn.tasks.filter.is_visible(kanban, task) and task.win_id ~= nil then
					kanban.fn.tasks.close(task)
				elseif task.title == "" and task.win_id ~= nil then
					kanban.fn.tasks.close(task)
				elseif kanban.fn.tasks.filter.is_visible(kanban, task) then
					show_count = show_count + 1
				end
				if kanban.fn.tasks.filter.is_visible(kanban, task) and task.win_id == nil then
					kanban.fn.tasks.open(kanban, task)
				end
			end
		end
		if show_count == 0 then
			kanban.fn.tasks.add(kanban, i, nil, "bottom", true)
		end
	end

	kanban.fn.tasks.resize(kanban)

	if #kanban.items.lists > 0 then
		for _, task in pairs(kanban.items.lists[1].tasks) do
			if task.win_id ~= nil then
				vim.fn.win_gotoid(task.win_id)
			end
		end
	end
end

function M.filter_by_tag(kanban)
	local tag_match = vim.fn.input("Filter -> ", kanban.ops.filter_tag)
	kanban.ops.filter_tag = tag_match
	M.filter(kanban)
end

function M.set_due_filter(kanban) end

function M.is_visible(kanban, task)
	local is_visible = false

	for _, tag in pairs(task.tag) do
		if string.match(tag, kanban.ops.filter_tag) ~= nil or task.title == "" then
			is_visible = true
		end
	end

	return is_visible
end
return M
