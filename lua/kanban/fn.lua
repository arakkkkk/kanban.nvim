local M = {}
-- Absolute path
local ap = "kanban."

M.kwindow = require(ap .. "fn.kwindow")
M.lists = require(ap .. "fn.lists")
M.tasks = require(ap .. "fn.tasks")
M.description = require(ap .. "fn.description")
return M
