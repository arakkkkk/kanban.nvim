local M = {}
function M.delete(kanban)
	if kanban.items.snip.buf_nr == nil then
		return
	end
	pcall(vim.cmd.bdelete, kanban.items.snip.buf_nr)
	kanban.items.snip = {}

	vim.keymap.set("i", "<cr>", "<cr>", { silent = true, buffer = vim.api.nvim_get_current_buf() })
end
return M
