local M = {}
-- Absolute path
local ap = "kanban.fn."

M.add = require(ap .. "tasks.add").add
M.close = require(ap .. "tasks.close").close
M.resize = require(ap .. "tasks.resize").resize
M.move_down = require(ap .. "tasks.move_down").move_down
M.move_up = require(ap .. "tasks.move_up").move_up
M.resize = require(ap .. "tasks.resize").resize
M.map = require(ap .. "tasks.map").map
return M


