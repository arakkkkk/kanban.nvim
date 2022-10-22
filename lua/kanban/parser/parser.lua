local Markdown = {}

function Markdown.parse(ops)
	local md = {}
	md.list = {
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
	return md
end

return Markdown
