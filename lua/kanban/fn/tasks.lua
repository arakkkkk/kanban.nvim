local M = {}
-- Absolute path
local ap = "kanban.fn."

M.add = require(ap .. "tasks.add").add
M.close = require(ap .. "tasks.close").close
M.close_all = require(ap .. "tasks.close_all").close_all
M.open = require(ap .. "tasks.open").open
M.resize = require(ap .. "tasks.resize").resize
M.move = require(ap .. "tasks.move")
M.take = require(ap .. "tasks.take")
M.delete = require(ap .. "tasks.delete").delete
M.resize = require(ap .. "tasks.resize").resize
M.save = require(ap .. "tasks.save").save
M.edit = require(ap .. "tasks.edit").edit
M.autocmd = require(ap .. "tasks.autocmd").autocmd
M.highlight = require(ap .. "tasks.highlight").highlight
M.sort = require(ap .. "tasks.sort").sort
M.filter = require(ap .. "tasks.filter").filter
M.snip = require(ap .. "tasks.snip").snip
M.utils = require(ap .. "tasks.utils")
return M


