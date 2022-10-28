local M = {}
-- Absolute path
local ap = "kanban.fn."

M.delete = require(ap .. "snip.delete").delete
M.popup = require(ap .. "snip.popup").popup
M.list_snip = require(ap .. "snip.list_snip").list_snip
return M


