local M = {}

function M.get_ops(options)
	options = options or {}
	local C = require("kanban.theme.colors")
	local ops = {
		move_position = "top", -- top or bottom
		add_position = "bottom", -- top or bottom
		board_path = vim.fn.stdpath("data") .. "/kanban/",
		layout = {
			x_margin = 5,
			y_margin = 3,
			list_x_margin = 2,
			task_y_margin = 2,
			task_height = 3,
			uncomplete_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			complete_border = { "✔", "─", "╮", "│", "╯", "─", "╰", "│" },
		},
		markdown = {
			description_folder = "./tasks/", -- "./"
			due_format = "YYYY-MM-DD",
			header = {
				"---",
				"",
				"kanban-plugin: basic",
				"",
				"---",
				"",
			},
			footer = {
				"",
				"",
				"%% kanban:settings",
				"```",
				'{"kanban-plugin":"basic"}',
				"```",
				"%%",
			},
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
				name = "TaskFloat", -- list border
				ops = {},
			},
			{
				name = "TaskFloatCompleted", -- card border
				fg = C.grey_1,
				ctermfg = 4,
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
				name = "TaskCompleted",
				ops = {
					fg = C.grey_1,
					ctermfg = 240,
					bold = false,
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
					bg = C.lock,
					ctermbg = 226,
				},
			},
			{
				name = "TaskDueSoon",
				ops = {
					fg = C.blue_4,
					ctermfg = 25,
					bold = true,
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

function M.picker(kanban)
	local files = vim.fn.globpath(kanban.ops.board_path, "**/*.md", true, true)
	if vim.tbl_isempty(files) then
		vim.notify("No kanban boards found in " .. kanban.ops.board_path, vim.log.levels.WARN)
		return
	end

	vim.ui.select(files, {
		prompt = "Select a Kanban board:",
		format_item = function(item)
			return vim.fn.fnamemodify(item, ":t")
		end,
	}, function(choice)
		if not choice then
			return
		end
		require("kanban").kanban_open(choice)
	end)
end

return M
