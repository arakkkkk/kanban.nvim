local M = {}
-- local utils = require("kanban.utils")
local function req(file_name)
  return require("kanban.items.lists." .. file_name)
end

function M.parser(ops)
	local lists = {}
	lists = {
		"a", "b", "c", "d"
	}
	lists = req("tasks.parser").parser(list)
	return lists
end


return M
