local M = {}

function M.parse(ops)
	local md = {}
	md.lists = require("kanban.parser.lists").parser(ops)
	for i in pairs(md.lists) do
		local task = require("kanban.parser.tasks").parser(ops, md.lists[i])
		md.lists[i].tasks = task
	end
	return md
end

return M
