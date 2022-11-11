local M = {}

function M.highlight(kanban, task)
	local lines = vim.fn.getbufline(task.buf_nr, 1, "$")
	local hi = vim.api.nvim_buf_add_highlight
	hi(task.buf_nr, 0, "TaskTitle", 0, 0, -1)
	for i = 2, #lines do
		vim.api.nvim_buf_clear_namespace(task.buf_nr, -1, i, i+1)
		if string.match(lines[i], "^" .. kanban.ops.markdown.due_head .. "%d%d%d%d/%d%d/%d%d$") then
			local due_count = kanban.fn.tasks.utils.count_due(lines[i])
			if due_count == 0 then
				hi(task.buf_nr, 0, "TaskDueToday", i - 1, 0, -1)
			elseif due_count < 0 then
				hi(task.buf_nr, 0, "TaskDueDead", i - 1, 0, -1)
			elseif 0 < due_count and due_count < 3 then
				hi(task.buf_nr, 0, "TaskDueSoon", i - 1, 0, -1)
			else
				hi(task.buf_nr, 0, "TaskDue", i - 1, 0, -1)
			end
			-- if string.match(lines[i], os.date("@%Y/%m/%d")) then
			-- end
		elseif string.match(lines[i], "^" .. kanban.ops.markdown.tag_head .. ".*$") then
			hi(task.buf_nr, 0, "TaskTag", i - 1, 0, -1)
		else
			hi(task.buf_nr, 0, "Normal", i - 1, 0, -1)
		end
	end
	vim.api.nvim_win_set_option(task.win_id, "winhighlight", "NormalFloat:TaskFloat")
end
return M
