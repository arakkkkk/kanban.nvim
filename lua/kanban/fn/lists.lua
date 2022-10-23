local M = {}
-- Absolute path
local ap = "kanban.fn."

M.add = require(ap .. "lists.add").add
M.close = require(ap .. "lists.close").close
M.resize = require(ap .. "lists.resize").resize
M.move_left = require(ap .. "lists.move_left").move_left
M.move_right = require(ap .. "lists.move_right").move_right
M.map = require(ap .. "lists.map").map
return M


