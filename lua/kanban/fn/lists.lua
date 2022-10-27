local M = {}
-- Absolute path
local ap = "kanban.fn."

M.add = require(ap .. "lists.add").add
M.close = require(ap .. "lists.close").close
M.delete = require(ap .. "lists.delete").delete
M.close_all = require(ap .. "lists.close_all").close_all
M.resize = require(ap .. "lists.resize").resize
M.rename = require(ap .. "lists.rename").rename
M.highlight = require(ap .. "lists.highlight").highlight
return M


