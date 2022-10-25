local M = {}

function M.init()
	local hi_config = require("kanban.theme.hi_config")
	for i in pairs(hi_config) do
		vim.fn.matchdelete(hi_config[i].name)
	end
end

return M
