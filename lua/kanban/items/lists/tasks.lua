local M = {}
-- local utils = require("kanban.utils")
local function req(file_name)
  return require("kanban.items.lists.tasks" .. file_name)
end

M.parser = req("tasks.parser").parser
return M

