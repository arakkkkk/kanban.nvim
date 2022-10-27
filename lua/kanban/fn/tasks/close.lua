local M = {}
function M.close(task)
	if task.buf_nr == nil then
		return
	end
	pcall(vim.cmd.bdelete, task.buf_nr)
	task.win_id = nil
	task.buf_nr = nil
end
return M
