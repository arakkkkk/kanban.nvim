local M = {}

function M.highlight(kanban, list)
	local hi = vim.api.nvim_buf_add_highlight
	hi(list.buf_nr, 0, "ListTitle", 1, 0, -1)
	vim.api.nvim_win_set_option(list.win_id, "winhighlight", "NormalFloat:ListFloat")
end
return M
