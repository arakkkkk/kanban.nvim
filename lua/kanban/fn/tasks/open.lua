local M = {}
function M.open(kanban, task)
	task.buf_nr = vim.api.nvim_create_buf(false, true)

	local window_text = kanban.fn.tasks.utils.create_window_text(kanban, task)
	vim.api.nvim_buf_set_lines(task.buf_nr, 0, -1, true, window_text)

	task.win_id = vim.api.nvim_open_win(task.buf_nr, true, task.buf_conf)
	vim.cmd("set filetype=kanban")

	kanban.fn.tasks.resize(kanban, 0)

	kanban.keymap(task.buf_nr)
	vim.keymap.set("n", ":q!<cr>", "<cmd>KanbanClose<cr>", { silent = true, buffer = kanban.items.kwindow.buf_nr })
	vim.keymap.set("n", ":q<cr>", "<cmd>KanbanClose<cr>", { silent = true, buffer = kanban.items.kwindow.buf_nr })
	vim.keymap.set("n", "q<cr>", "<cmd>KanbanClose<cr>", { silent = true, buffer = kanban.items.kwindow.buf_nr })
	kanban.fn.tasks.highlight(kanban, task)
	kanban.fn.tasks.autocmd(kanban, task)
end

return M
