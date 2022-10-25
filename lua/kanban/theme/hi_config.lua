local C = require("kanban.theme.colors")
local hi_cnofig = {
	{
		name = "TaskDue",
		pattern = "^@.*",
		bg = "none",
		fg = C.blue_4,
	},
	{
		name = "TaskTag",
		pattern = "^#.*$",
		bg = "",
		fg = C.gold,
	},
	{
		name = "",
		pattern = "",
		bg = "none",
		fg = "none",
	},
	{
		name = "",
		pattern = "",
		bg = "none",
		fg = "none",
	},
	{
		name = "",
		pattern = "",
		bg = "none",
		fg = "none",
	},
	{
		name = "",
		pattern = "",
		bg = "none",
		fg = "none",
	},
}
return hi_cnofig
