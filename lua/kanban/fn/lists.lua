local M = {}
-- Absolute path
local ap = "kanban.fn."

M.add = require(ap .. "lists.add").add
M.close = require(ap .. "lists.close").close
M.resize = require(ap .. "lists.resize").resize
return M


