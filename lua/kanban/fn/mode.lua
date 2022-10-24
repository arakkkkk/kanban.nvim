local M = {}
-- Absolute path
local ap = "kanban.fn."

M.insert = require(ap .. "tasks.insert")
M.normal = require(ap .. "tasks.normal")
return M



