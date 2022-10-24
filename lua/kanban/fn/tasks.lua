local M = {}
-- Absolute path
local ap = "kanban.fn."

M.add = require(ap .. "tasks.add").add
M.close = require(ap .. "tasks.close").close
M.close_all = require(ap .. "tasks.close_all").close_all
M.open = require(ap .. "tasks.open").open
M.resize = require(ap .. "tasks.resize").resize
-- M.move_down = require(ap .. "tasks.move_down").move_down
-- M.move_up = require(ap .. "tasks.move_up").move_up
-- M.move_left = require(ap .. "tasks.move_left").move_left
-- M.move_right = require(ap .. "tasks.move_right").move_right
M.move = require(ap .. "tasks.move")
M.take_left = require(ap .. "tasks.take_left").take_left
M.take_right = require(ap .. "tasks.take_right").take_right
M.delete = require(ap .. "tasks.delete").delete
M.resize = require(ap .. "tasks.resize").resize
M.map = require(ap .. "tasks.map").map
M.utils = require(ap .. "tasks.utils")
return M


