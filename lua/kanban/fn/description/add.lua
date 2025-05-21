local M = {}
-- Absolute path
function M.add(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	local task = focused_list.tasks[focus.task_num]
	kanban.items.description = { task = task }

	-- create kanban panel
	kanban.items.description.buf_nr = vim.api.nvim_create_buf(false, "throwaway")

	kanban.items.description.buf_conf = {
		relative = "editor",
		row = kanban.ops.layout.y_margin,
		col = kanban.ops.layout.x_margin,
		width = kanban.items.kwindow.buf_conf.width,
		height = kanban.items.kwindow.buf_conf.height,
		border = "rounded",
		style = "minimal",
		zindex = 40,
	}
	local win = vim.api.nvim_open_win(kanban.items.description.buf_nr, true, kanban.items.description.buf_conf)
	vim.api.nvim_win_set_option(win, "winhighlight", "NormalFloat:KanbanFloat")
	local current_md_dir = string.gsub(kanban.kanban_md_path, "/[^/]+$", "")
	if vim.fn.isdirectory(vim.fn.expand(current_md_dir .. "/" .. kanban.ops.markdown.description_folder)) == 0 then
		vim.fn.mkdir(vim.fn.expand(current_md_dir .. "/" .. kanban.ops.markdown.description_folder))
	end

	-- arrange task_title/description file name
	local task_title = task.lines[1]
	task_title = task_title:gsub(" ", "_")
	task_title = task_title:gsub("%%", "")
	task_title = task_title:gsub("#", "")

	local file_path = current_md_dir .. "/" .. kanban.ops.markdown.description_folder .. task_title .. ".md"
	vim.cmd(":e " .. file_path)
	local bufnr = vim.api.nvim_win_get_buf(0)
	vim.bo[bufnr]["bufhidden"] = "delete"

	kanban.fn.description.set_header(kanban)

	vim.api.nvim_create_autocmd("BufWinLeave", {
		once = true,
		pattern = "<buffer=" .. kanban.items.description.buf_nr .. ">",
		callback = function()
			kanban.items.description = {}
			vim.fn.win_gotoid(task.win_id)
		end,
	})
end
return M
