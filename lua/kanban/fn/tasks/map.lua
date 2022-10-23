local M = {}

local move_down = require("kanban.fn.tasks.move_down")
local move_up = require("kanban.fn.tasks.move_up")

function M.map(task)
	vim.keymap.set("n", "<C-j>", move_down(), { silent = true, buffer = task.buf_nr })
	vim.keymap.set("n", "<C-k>", move_up(), { silent = true, buffer = task.buf_nr })
end

return M
