local M = {}

function M.map(kanban, list)

	vim.keymap.set("n", "<C-l>", function()
		kanban.fn.lists.move_right()
	end, { silent = true, buffer = list.buf_nr })
	vim.keymap.set("n", "<C-h>", function()
		kanban.fn.lists.move_left()
	end, { silent = true, buffer = list.buf_nr })

	vim.keymap.set("n", ":q<cr>", function()
		kanban.fn.kwindow.close(kanban)
		kanban.fn.lists.close(kanban)
		kanban.fn.tasks.close(kanban)
	end, { silent = true, buffer = list.buf_nr })

end

return M
