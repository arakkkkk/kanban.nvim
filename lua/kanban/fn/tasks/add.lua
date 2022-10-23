local M = {}
-- Absolute path
function M.add(kanban, list_title, task, open_window)
	local target_list
	for i in pairs(kanban.items.lists) do
		local list = kanban.items.lists[i]
		if list.title == list_title then
			target_list = list
			break
		end
	end

	local tasks = target_list.tasks
	tasks[#tasks + 1] = task

	if open_window then
		tasks[#tasks].buf_nr = vim.api.nvim_create_buf(false, "nomodeline")
		vim.api.nvim_buf_set_lines(tasks[#tasks].buf_nr, 0, -1, true, { task.title })

		tasks[#tasks].buf_conf = {
			relative = "editor",
			row = target_list.buf_conf.row + 4 + (kanban.ops.layout.task_height + 2)*(#tasks-1),
			col = target_list.buf_conf.col + 2,
			width = target_list.buf_conf.width - 4,
			height = kanban.ops.layout.task_height,
			border = "rounded",
			style = "minimal",
			zindex = 50,
		}

		tasks[#tasks].win_id = vim.api.nvim_open_win(tasks[#tasks].buf_nr, true, tasks[#tasks].buf_conf)

		kanban.fn.tasks.resize(kanban)

		vim.api.nvim_create_autocmd("BufWinLeave", {
			once = true,
			callback = function()
				kanban.fn.tasks.close(kanban)
			end,
		})

	else
		return

	end
end
return M
