local M = {}
-- Absolute path
local ap = "kanban.fn."

M.add = require(ap .. "description.add").add
return M
