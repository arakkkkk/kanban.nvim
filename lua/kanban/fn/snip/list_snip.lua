local M = {}
M.list_snip = {}
function M.list_snip.due(kanban, line)
	local list_snip = { line }
	return list_snip
end

function M.list_snip.tag(kanban, line)
	local list_snip = { line }
	return list_snip
end
return M
