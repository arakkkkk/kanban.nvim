local M = {}

function M.map(kanban, task)
	vim.g.mapleader = " "

	-- Swich mode
	vim.keymap.set("i", "<C-c>", "<esc>", { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", ":w<cr>", function()
		kanban.fn.tasks.save(kanban)
		kanban.markdown.writer.write(kanban, kanban.kanban_md_path)
	end, { silent = true, buffer = task.buf_nr })

	-- Task movement
	vim.keymap.set("n", "L", function()
		kanban.fn.tasks.take.right(kanban)
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "H", function()
		kanban.fn.tasks.take.left(kanban)
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "K", function()
		kanban.fn.tasks.take.up(kanban)
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "J", function()
		kanban.fn.tasks.take.down(kanban)
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
		kanban.fn.tasks.move.top(kanban, task)
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "G", function()
		kanban.fn.tasks.move.bottom(kanban, task)
	end, { silent = true, buffer = task.buf_nr })

	-- delete task
	-- vim.keymap.set("n", "D", function()
	-- 	kanban.fn.tasks.delete(kanban, task)
	-- end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "d", "<cmd>KanbanTaskDelete<cr>", { silent = true, buffer = task.buf_nr })

	-- create task
	vim.keymap.set("n", "o", function()
		kanban.fn.tasks.add(kanban, nil, nil, "bottom", true)
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "O", function()
		kanban.fn.tasks.add(kanban, nil, nil, "top", true)
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

	-- List function
	vim.keymap.set("n", "<leader>ld", function()
		kanban.fn.lists.delete(kanban)
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "<leader>lr", function()
		kanban.fn.lists.rename(kanban)
	end, { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "<leader>la", function()
		kanban.fn.lists.add(kanban, "List", true)
	end, { silent = true, buffer = task.buf_nr })

	-- Description note
	vim.keymap.set("n", "<CR>", function()
		kanban.fn.lists.add(kanban)
	end, { silent = true, buffer = task.buf_nr })

	-- delete
	vim.keymap.set("n", "<C-o>", "k", { silent = true, buffer = task.buf_nr })
end

return M
