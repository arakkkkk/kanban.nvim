local Utils = {}

function Utils.buf_delete(kanban)
	local list = kanban.items.list

	local function bd(n)
		vim.cmd.bdelete(n)
	end

	for i = 1, #list do
		pcall(bd, list[i])
	end
	pcall(vim.cmd.bdelete, kanban.items.kwindow)
end

function Utils.tablelength(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

function Utils.get_show_task_int(kanban)
	local list_heihgt = kanban.items.lists[1].buf_conf.height
	local task_area_height = list_heihgt - 4 - 2
	local task_height = kanban.ops.layout.task_height + 2
  local show_task_height = task_area_height / task_height
	return show_task_height
end

return Utils
