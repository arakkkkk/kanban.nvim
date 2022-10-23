local M = {}

function M.map(kanban, task)

	vim.keymap.set("n", "<C-j>", function()
		kanban.fn.tasks.move_down(kanban, task)
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "<C-k>", function()
		kanban.fn.tasks.move_up(kanban, task)
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "<C-l>", function()
		kanban.fn.tasks.move_right(kanban, task)
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "<C-h>", function()
		kanban.fn.tasks.move_left(kanban, task)
	end, { silent = true, buffer = task.buf_nr })

	vim.keymap.set("n", "L", function()
		kanban.fn.tasks.take_right(kanban, task)
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "H", function()
		kanban.fn.tasks.take_left(kanban, task)
	end, { silent = true, buffer = task.buf_nr })

	vim.keymap.set("n", "D", function()
		kanban.fn.tasks.delete(kanban, task)
	end, { silent = true, buffer = task.buf_nr })

	vim.keymap.set("n", ":q<cr>", function()
		kanban.fn.kwindow.close(kanban)
		kanban.fn.lists.close_all(kanban)
		kanban.fn.tasks.close_all(kanban)
	end, { silent = true, buffer = task.buf_nr })

end

return M
