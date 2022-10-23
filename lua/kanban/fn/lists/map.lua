local M = {}

function M.map(kanban, list)

	vim.keymap.set("n", ":q<cr>", function()
		kanban.fn.kwindow.close(kanban)
		kanban.fn.lists.close_all(kanban)
		kanban.fn.tasks.close_all(kanban)
	end, { silent = true, buffer = list.buf_nr })

end

return M
