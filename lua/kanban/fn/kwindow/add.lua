local M = {}
-- Absolute path
function M.add(kanban)
	-- create kanban panel
	kanban.items.kwindow.buf_nr = vim.api.nvim_create_buf(false, "nomodeline")
	vim.api.nvim_buf_set_lines(kanban.items.kwindow.buf_nr, 0, -1, true, { "", "  Kanban.nvim" })
	kanban.items.kwindow.buf_conf = {
		relative = "editor",
		row = kanban.ops.layout.y_margin,
		col = kanban.ops.layout.x_margin,
		width = vim.o.columns - kanban.ops.layout.x_margin * 2,
		height = vim.fn.winheight(0) - kanban.ops.layout.y_margin * 2,
		-- border = "rounded",
		-- border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
		border = { "x", "═", "x", "║", "x", "═", "x", "║" },
		-- border = { "┳", "━", "┳", "┃", "┫", "━", "┣", "┃" },
		style = "minimal",
		zindex = 10,
	}
	local hi = vim.api.nvim_buf_add_highlight
	hi(kanban.items.kwindow.buf_nr, 0, "ListTitle", 1, 0, -1)
	local win = vim.api.nvim_open_win(kanban.items.kwindow.buf_nr, true, kanban.items.kwindow.buf_conf)
	-- kanban.fn.kwindow.autocmd(kanban)
	vim.api.nvim_win_set_option(win, "winhighlight", "NormalFloat:KanbanFloat")
	vim.keymap.set("n", ":q!<cr>", "<cmd>KanbanClose<cr>", { silent = true, buffer = kanban.items.kwindow.buf_nr })
	vim.keymap.set("n", ":q<cr>", "<cmd>KanbanClose<cr>", { silent = true, buffer = kanban.items.kwindow.buf_nr })
	vim.keymap.set("n", "q<cr>", "<cmd>KanbanClose<cr>", { silent = true, buffer = kanban.items.kwindow.buf_nr })
end
return M
