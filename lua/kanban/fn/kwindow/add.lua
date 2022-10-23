local M = {}
-- Absolute path
function M.add(kanban)
	-- create kanban panel
	kanban.items.kwindow.buf_nr = vim.api.nvim_create_buf(false, "nomodeline")
	vim.api.nvim_buf_set_lines(
		kanban.items.kwindow.buf_nr, 0, -1, true, {"", "  Kanban.nvim"})
	kanban.items.kwindow.buf_conf = {
		relative = "win",
		row = kanban.ops.layout.y_margin,
		col = kanban.ops.layout.x_margin,
		width = vim.fn.winwidth(0) - kanban.ops.layout.x_margin*2,
		height = vim.fn.winheight(0) - kanban.ops.layout.y_margin*2,
		border = "rounded",
		style = "minimal",
		zindex = 1
	}
	vim.api.nvim_open_win(kanban.items.kwindow.buf_nr, true, kanban.items.kwindow.buf_conf)
end
return M


