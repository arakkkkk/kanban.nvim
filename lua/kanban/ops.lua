local M = {}

function M.get_ops(options)
	local C = require("kanban.theme.colors")
	local ops = {
		move_position = "top", -- top or bottom
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
				name = "KanbanTitle",
				ops = {
					bg = "None",
					fg = "None",
					ctermbg = "None",
					ctermfg = "None",
					bold = true,
				},
			},
			{
				name = "ListTitle",
				ops = {
					bg = "None",
					fg = "None",
					ctermbg = "None",
					ctermfg = "None",
					bold = true,
				},
			},
			{
				name = "TaskTitle",
				ops = {
					bg = "None",
					fg = "None",
					ctermbg = "None",
					ctermfg = "None",
					bold = true,
				},
			},
			{
				name = "TaskDue",
				ops = {
					bg = "None",
					fg = C.blue_4,
					ctermbg = "None",
					ctermfg = 25,
				},
			},
			{
				name = "TaskTag",
				ops = {
					bg = "None",
					fg = C.gold,
					ctermbg = "None",
					ctermfg = 221,
				},
			},
		},
	}
	ops = require("kanban.utils").tableMerge(ops, options)
	return ops
end

return M
