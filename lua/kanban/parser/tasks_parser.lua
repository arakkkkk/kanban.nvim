local M = {}

function M.parser(ops, lists)
	local tasks = {
		{ title = "1", desc = "desc", due = "yyyy/mm/dd" },
		{ title = "2", desc = "desc", due = "yyyy/mm/dd" },
		{ title = "3", desc = "desc", due = "yyyy/mm/dd" },
	}
	return tasks
end

return M

