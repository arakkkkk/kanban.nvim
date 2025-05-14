local M = {}

function M.autocmd(kanban, task)
	vim.cmd("set filetype=kanban")

	-- onchange
	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "TextChangedP" }, {
		pattern = "<buffer=" .. task.buf_nr .. ">",
		callback = function()
			kanban.fn.tasks.save(kanban)
			kanban.fn.tasks.highlight(kanban, task)
		end,
	})

	-- on normal
	vim.api.nvim_create_autocmd("InsertLeave", {
		pattern = "<buffer=" .. task.buf_nr .. ">",
		callback = function()
			vim.api.nvim_win_set_cursor(0, { 1, 0 })
			kanban.fn.tasks.highlight(kanban, task)
		end,
	})
end

return M
