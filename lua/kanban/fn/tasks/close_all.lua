local M = {}
function M.close_all(kanban)
	local lists = kanban.items.lists
	for i = 1, #lists do
		local list = kanban.items.lists[i]
		for j in pairs(list.tasks) do
			pcall(vim.cmd.bdelete, list.tasks[j].buf_nr)
		end
	end
end
return M
