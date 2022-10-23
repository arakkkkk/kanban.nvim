local M = {}
-- Absolute path
local ap = "kanban.fn."

M.add = require(ap .. "tasks.add").add
return M


