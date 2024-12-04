local M = {}

function M.keymap(buf)
	local ops = { silent = true, buffer = buf }

	vim.g.mapleader = " "

	-- Default
	vim.keymap.set("i", "<C-c>", "<esc>", ops)
	vim.keymap.set("n", "<C-o>", "k", ops)
	vim.keymap.set("n", ":w<cr>", "<cmd>KanbanSave<cr>", ops)
	vim.keymap.set("n", ":q<cr>", "<cmd>KanbanClose<cr>", ops)
	vim.keymap.set("n", "q", "<cmd>KanbanClose<cr>", ops)

	-- Task movement
	vim.keymap.set("n", "L", "<cmd>KanbanTakeRight<cr>", ops)
	vim.keymap.set("n", "H", "<cmd>KanbanTakeLeft<cr>", ops)
	vim.keymap.set("n", "K", "<cmd>KanbanTakeUp<cr>", ops)
	vim.keymap.set("n", "J", "<cmd>KanbanTakeDown<cr>", ops)

	-- Task navigation
	vim.keymap.set("n", "<C-j>", "<cmd>KanbanMoveDown<cr>", ops)
	vim.keymap.set("n", "<C-k>", "<cmd>KanbanMoveUp<cr>", ops)
	vim.keymap.set("n", "<C-l>", "<cmd>KanbanMoveRight<cr>", ops)
	vim.keymap.set("n", "<C-h>", "<cmd>KanbanMoveLeft<cr>", ops)
	vim.keymap.set("n", "gg", "<cmd>KanbanMoveTop<cr>", ops)
	vim.keymap.set("n", "G", "<cmd>KanbanMoveBottom<cr>", ops)

	-- Task manager
	vim.keymap.set("n", "D", "<cmd>KanbanTaskDelete<cr>", ops)
	vim.keymap.set("n", "<C-o>", "<cmd>KanbanTaskAdd<cr>", ops)
	vim.keymap.set("n", "<C-t>", "<cmd>KanbanTaskToggleComplete<cr>", ops)

	-- List manager
	vim.keymap.set("n", "<leader>ld", "<cmd>KanbanListDelete<cr>", ops)
	vim.keymap.set("n", "<leader>lr", "<cmd>KanbanListRename<cr>", ops)
	vim.keymap.set("n", "<leader>la", "<cmd>KanbanListAdd<cr>", ops)

	-- Description note
	vim.keymap.set("n", "<CR>", "<cmd>KanbanTaskDescription<cr>", ops)
end

return M
