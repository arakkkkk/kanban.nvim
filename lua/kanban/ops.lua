local M = {}

function M.get_ops(options)
	local C = require("kanban.theme.colors")
	local ops = {
		move_position = "top", -- top or bottom
		add_position = "bottom", -- top or bottom
		kanban_md_path = {
			"~/local_file/practice/kanban.nvim/template.md",
			"/Users/Kouiti/local_file/practice/kanban.nvim/template.md",
			"/Users/kouiti/localfile/plug-nvim/kanban.nvim/template.md",
		},
		layout = {
			x_margin = 5,
			y_margin = 3,
			list_x_margin = 2,
			task_y_margin = 2,
			task_height = 3,
		},
		markdown = {
			description_folder = "./kanban/", -- "./"
			list_head = "## ",
			title_head = "- [ ] ",
			title_style = "[[<title>]]",
			due_head = "@",
			due_style = "{<due>}",
			tag_head = "#",
			tag_style = "<tag>",
			header = {
				"---",
				"",
				"kanban-plugin: basic",
				"",
				"---",
			},
			footer = {},
		},
		hl = {
			{
				name = "KanbanFloat",
				ops = {},
			},
			{
				name = "ListFloat",
				ops = {},
			},
			{
				name = "TaskFloat",
				ops = {},
			},
			{
				name = "KanbanTitle",
				ops = {
					bold = true,
				},
			},
			{
				name = "ListTitle",
				ops = {
					bold = true,
				},
			},
			{
				name = "TaskTitle",
				ops = {
					bold = true,
				},
			},
			{
				name = "TaskDue",
				ops = {
					fg = C.blue_4,
					ctermfg = 25,
				},
			},
			{
				name = "TaskDueToday",
				ops = {
					bg = C.blue_3,
					ctermbg = 67,
				},
			},
			{
				name = "TaskDueDead",
				ops = {
					bg = C.blue_3,
					ctermbg = 26,
				},
			},
			{
				name = "TaskTag",
				ops = {
					fg = C.gold,
					ctermfg = 221,
				},
			},
		},
	}
	ops = require("kanban.utils").tableMerge(ops, options)
	return ops
end

return M
