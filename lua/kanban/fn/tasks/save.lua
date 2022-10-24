local M = {}
function M.save(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	local task = focused_list.tasks[focus.task_num]
	local lines = vim.fn.getbufline(task.buf_nr, 1, "$")

	local title = lines[1]
	local due = {}
	local tag = {}
	for i = 2, #lines do
		if string.match(lines[i], "^"..kanban.ops.markdown.due_head .. ".*$") then
			table.insert(due, lines[i])
		elseif string.match(lines[i], "^"..kanban.ops.markdown.tag_head .. ".*$") then
			table.insert(tag, lines[i])
		else
			vim.api.nvim_command("echohl WarningMsg")
      vim.api.nvim_command("echo 'Format error!'")
      vim.api.nvim_command("echohl None")
      kanban.fn.tasks.close(task)
      kanban.fn.tasks.open(kanban, task)
      return
		end
	end

	task.title = title
	task.due = due
	task.tag = tag
end
return M
