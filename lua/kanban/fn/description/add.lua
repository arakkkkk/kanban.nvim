local M = {}
-- Absolute path
function M.add(kanban)
	-- create kanban panel
	local taskwinid = vim.fn.win_getid()
	kanban.items.description = {}

	kanban.items.description.buf_nr = vim.api.nvim_create_buf(false, "nomodeline")
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

	local task_title = vim.fn.getbufline(0, 1, "$")
	local current_md_dir = string.gsub(kanban.kanban_md_path, "/[^/]+$", "")
	local file_path = current_md_dir .."/".. kanban.ops.markdown.description_folder .. task_title[1] .. ".md"
	vim.cmd(":e " .. file_path)

	vim.api.nvim_create_autocmd("BufWinLeave", {
		once = true,
		pattern = "<buffer=" .. kanban.items.description.buf_nr .. ">",
		callback = function()
			vim.fn.win_gotoid(taskwinid)
		end,
	})
end
return M
