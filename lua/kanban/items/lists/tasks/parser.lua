local M = {}

function M.parser(ops)
	local lists = {}
	lists = {
		a = {
		  { title = "1", desc = "desc", due = "yyyy/mm/dd" },
		  { title = "2", desc = "desc", due = "yyyy/mm/dd" },
		  { title = "3", desc = "desc", due = "yyyy/mm/dd" },
		},
		b = {
		  { title = "1", desc = "desc", due = "yyyy/mm/dd" },
		  { title = "2", desc = "desc", due = "yyyy/mm/dd" },
		  { title = "3", desc = "desc", due = "yyyy/mm/dd" },
		},
		c = {
		  { title = "1", desc = "desc", due = "yyyy/mm/dd" },
		  { title = "2", desc = "desc", due = "yyyy/mm/dd" },
		  { title = "3", desc = "desc", due = "yyyy/mm/dd" },
		},
		d = {
		  { title = "1", desc = "desc", due = "yyyy/mm/dd" },
		  { title = "2", desc = "desc", due = "yyyy/mm/dd" },
		  { title = "3", desc = "desc", due = "yyyy/mm/dd" },
		},
	}
	return lists
end


return M

