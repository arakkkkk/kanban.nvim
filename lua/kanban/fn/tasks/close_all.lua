local M = {}
function M.close_all(kanban)
	local lists = kanban.items.lists
	for i = 1, #lists do
		local list = kanban.items.lists[i]
		for j in pairs(list.tasks) do
			kanban.fn.tasks.close(list.tasks[j])
		end
	end
end
return M
