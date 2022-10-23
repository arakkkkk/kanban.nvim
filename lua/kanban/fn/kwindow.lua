local M = {}
-- Absolute path
local ap = "kanban.fn."

M.add = require(ap .. "kwindow.add").add
M.add_with_md = require(ap .. "kwindow.add").add_with_md
M.close = require(ap .. "kwindow.close").close
return M

