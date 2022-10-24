local M = {}
-- Absolute path
local ap = "kanban."

M.parse = require(ap .. "parser.parse").parse
M.template = require(ap .. "parser.template")

return M


