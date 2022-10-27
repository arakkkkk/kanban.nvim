local M = {}
function M.close(list)
	pcall(vim.cmd.bdelete, list.buf_nr)
	list.win_id = nil
	list.buf_nr = nil
end
return M
