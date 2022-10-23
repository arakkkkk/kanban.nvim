local M = {}
function M.close(kanban)
	pcall(vim.cmd.bdelete, kanban.items.kwindow.buf_nr)
end
return M
