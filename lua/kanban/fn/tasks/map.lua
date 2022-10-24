local M = {}

function M.map(kanban, task)

	-- Task movement
	vim.keymap.set("n", "L", function()
		kanban.fn.tasks.take.right(kanban)
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "H", function()
		kanban.fn.tasks.take.left(kanban)
	end, { silent = true, buffer = task.buf_nr })

	-- Navigatiion task
	vim.keymap.set("n", "<C-j>", function()
		kanban.fn.tasks.move.down(kanban)
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "<C-k>", function()
		kanban.fn.tasks.move.up(kanban)
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "<C-l>", function()
		kanban.fn.tasks.move.right(kanban)
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "<C-h>", function()
		kanban.fn.tasks.move.left(kanban)
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "gg", function()
		kanban.fn.tasks.utils.move_top(kanban, task)
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "G", function()
		kanban.fn.tasks.utils.move_bottom(kanban, task)
	end, { silent = true, buffer = task.buf_nr })

	-- delete task
	vim.keymap.set("n", "d", function()
		kanban.fn.tasks.delete(kanban, task)
	end, { silent = true, buffer = task.buf_nr })

	-- close window
	vim.keymap.set("n", ":q<cr>", function()
		kanban.fn.kwindow.close(kanban)
		kanban.fn.lists.close_all(kanban)
		kanban.fn.tasks.close_all(kanban)
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "q", function()
		kanban.fn.kwindow.close(kanban)
		kanban.fn.lists.close_all(kanban)
		kanban.fn.tasks.close_all(kanban)
	end, { silent = true, buffer = task.buf_nr })

end

return M
