local Markdown = {}

function Markdown.parser(ops)
	local md = {}
	md.lists = require("kanban.parser.lists_parser").parser(ops)
	for i in pairs(md.lists) do
		local task = require("kanban.parser.tasks_parser").parser(ops, md.lists[i])
		md.lists[i].tasks = task
	end
	return md
end

return Markdown
