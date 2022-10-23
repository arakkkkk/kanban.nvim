local M = {}
-- local utils = require("kanban.utils")
local function req(file_name)
  return require("kanban.items." .. file_name)
end

M.parser = req("lists.parser").parser
return M

