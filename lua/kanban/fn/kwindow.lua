local M = {}
-- Absolute path
local ap = "kanban.fn."

M.add = require(ap .. "kwindow.add").add
M.close = require(ap .. "kwindow.close").close
M.autocmd = require(ap .. "kwindow.autocmd").autocmd
return M

