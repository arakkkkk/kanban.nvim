local M = {}
function M.delete(kanban)
	pcall(vim.cmd.bdelete, kanban.items.snip.buf_nr)
end
return M
