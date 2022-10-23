local M = {}
function M.close(task)
	pcall(vim.cmd.bdelete, task.buf_nr)
	task.win_id = nil
	task.buf_nr = nil
end
return M
