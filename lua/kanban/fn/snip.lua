local M = {}
-- Absolute path
local ap = "kanban.fn."

M.delete = require(ap .. "snip.delete").delete
M.popup = require(ap .. "snip.popup").popup
M.get_cmp = require(ap .. "snip.get_cmp").get_cmp
return M


