local M = {}

function M.add(kanban, title, with_blank_task_bool)
	local lists = kanban.items.lists

	lists[#lists + 1] = {
		title = title,
		tasks = {},
	}
	lists[#lists].buf_nr = vim.api.nvim_create_buf(false, "nomodeline")
	vim.api.nvim_buf_set_lines(lists[#lists].buf_nr, 0, -1, true, { "", "  " .. title })

	lists[#lists].buf_conf = {
		relative = "editor",
		row = 10,
		col = 12 + #lists,
		width = 10,
		height = kanban.items.kwindow.buf_conf.height - 6,
		-- border = "rounded",
		border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		-- border = { "x", "─", "x", "│", "x", "─", "x", "│" },
		style = "minimal",
		zindex = 20,
	}

	lists[#lists].win_id = vim.api.nvim_open_win(lists[#lists].buf_nr, true, lists[#lists].buf_conf)

	if with_blank_task_bool then
		local task = kanban.fn.tasks.add(kanban, #lists, nil, "bottom", true)
		lists[#lists].tasks[1] = task
	end
	kanban.fn.lists.highlight(kanban, lists[#lists])
	kanban.fn.lists.resize(kanban)
	kanban.fn.tasks.resize(kanban)
end
return M
