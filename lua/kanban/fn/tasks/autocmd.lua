local M = {}

function M.autocmd(kanban, task)
	vim.api.nvim_create_autocmd("InsertLeave", {
		once = true,
		pattern = "<buffer=" .. task.buf_nr .. ">",
		callback = function()
			kanban.fn.tasks.save(kanban)
			kanban.fn.tasks.highlight(kanban, task)
		end,
	})

	-- vim.api.nvim_create_autocmd("BufEnter", {
	-- 	once = true,
	-- 	pattern = "<buffer=" .. task.buf_nr .. ">",
	-- 	callback = function()
	-- 		vim.api.nvim_win_set_option(task.win_id, "winhighlight", "Normal:TaskSelected")
	-- 	end,
	-- })
	-- vim.api.nvim_create_autocmd("BufLeave", {
	-- 	once = true,
	-- 	pattern = "<buffer=" .. task.buf_nr .. ">",
	-- 	callback = function()
	-- 		vim.api.nvim_win_set_option(task.win_id, "winhighlight", "Normal:Normal")
	-- 	end,
	-- })
end

return M
