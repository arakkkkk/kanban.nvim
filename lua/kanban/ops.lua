local M = {}
-- local utils = require("kanban.utils")
local function req(file_name)
  return require("kanban." .. file_name)
end

M.setup_ops = req("ops.setup_ops").setup_ops
return M
