local M = {}
-- local utils = require("kanban.utils")
local function req(file_name)
  return require("kanban." .. file_name)
end

-- M.kanban = req("items.kanban")
M.lists = req("items.lists")
return M


