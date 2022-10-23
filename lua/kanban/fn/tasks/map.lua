local M = {}

function M.map(kanban, task)

	vim.keymap.set("n", "<C-j>", function()
		kanban.fn.tasks.move_down()
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "<C-k>", function()
		kanban.fn.tasks.move_up()
	end, { silent = true, buffer = task.buf_nr })

	vim.keymap.set("n", ":q<cr>", function()
		kanban.fn.kwindow.close(kanban)
		kanban.fn.lists.close(kanban)
		kanban.fn.tasks.close(kanban)
	end, { silent = true, buffer = task.buf_nr })

end

return M
