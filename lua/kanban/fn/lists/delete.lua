local M = {}

function M.delete(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	if #kanban.items.lists < 2 then
		print("It is only one list.")
		return
	end

	-- Change focus
	if focus.list_num == #kanban.items.lists then
		kanban.fn.tasks.move.left(kanban)
	else
		kanban.fn.tasks.move.right(kanban)
	end

	-- Delete list
	kanban.fn.lists.close(focused_list)
	for i in pairs(focused_list.tasks) do
		kanban.fn.tasks.close(focused_list.tasks[i])
	end
	table.remove(kanban.items.lists, focus.list_num)

	-- Resize
	kanban.fn.lists.resize(kanban)
	kanban.fn.tasks.resize(kanban)
end

return M
