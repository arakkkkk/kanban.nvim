local M = {}

function M.highlight(kanban, task)
	local utils = require("kanban.utils")
	local lines = vim.fn.getbufline(task.buf_nr, 1, "$")
	local hi = vim.api.nvim_buf_add_highlight

	if not task.check then
		-- Uncompleted card
		hi(task.buf_nr, 0, "TaskTitle", 0, 0, -1)
		vim.api.nvim_win_set_option(task.win_id, "winhighlight", "NormalFloat:TaskFloat")
		for i = 1, #lines do
			local line = lines[i]
			vim.api.nvim_buf_clear_namespace(task.buf_nr, -1, i, i + 1)

			hi(task.buf_nr, 0, "Normal", i - 1, 0, -1)

			-- Due
			local date_format_regexp = string.gsub(kanban.ops.markdown.due_format, "[YMD]", "%%d")
			date_format_regexp = utils.to_regexp(date_format_regexp)
			for start_idx, due, end_idx in line:gmatch("()@(" .. date_format_regexp .. ")()") do
				local due_count = kanban.fn.tasks.utils.count_due(lines[i])
				if due_count == 0 then
					hi(task.buf_nr, 0, "TaskDueToday", i - 1, start_idx - 1, end_idx)
				elseif due_count < 0 then
					hi(task.buf_nr, 0, "TaskDueDead", i - 1, start_idx - 1, end_idx)
				elseif 0 < due_count and due_count < 3 then
					hi(task.buf_nr, 0, "TaskDueSoon", i - 1, start_idx - 1, end_idx)
				else
					hi(task.buf_nr, 0, "TaskDue", i - 1, start_idx - 1, end_idx)
				end
			end

			-- Tag: Start at the beginning of a line
			if line:match("^#%w+") then
				local start_idx, end_idx = line:find("^#%w+")
				vim.api.nvim_buf_add_highlight(task.buf_nr, 0, "TaskTag", i - 1, start_idx - 1, end_idx)
			end
			-- Tag: Following a space
			for start_idx, end_idx in line:gmatch("()%s#%w+()") do
				vim.api.nvim_buf_add_highlight(task.buf_nr, 0, "TaskTag", i - 1, start_idx - 1, end_idx - 1)
			end
		end
	else
		-- Completed card
		for i = 1, #lines do
			hi(task.buf_nr, 0, "TaskCompleted", i - 1, 0, -1)
		end
		vim.api.nvim_win_set_option(task.win_id, "winhl", "FloatBorder:TaskFloatCompleted")
	end
end
return M
