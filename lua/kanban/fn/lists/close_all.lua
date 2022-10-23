local M = {}
function M.close_all(kanban)
	local lists = kanban.items.lists
	for i = 1, #lists do
		pcall(vim.cmd.bdelete, lists[i].buf_nr)
	end
end
return M
