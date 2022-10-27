local M = {}
function M.close(list)
	pcall(vim.cmd.bdelete, list.buf_nr)
end
return M
