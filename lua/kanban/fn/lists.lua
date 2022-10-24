local M = {}
-- Absolute path
local ap = "kanban.fn."

M.add = require(ap .. "lists.add").add
M.close = require(ap .. "lists.close").close
M.close_all = require(ap .. "lists.close_all").close_all
M.resize = require(ap .. "lists.resize").resize
M.map = require(ap .. "lists.map").map
M.rename = require(ap .. "lists.rename").rename
return M


