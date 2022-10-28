local M = {}

function M.autocmd(kanban, task)
	vim.cmd("set filetype=kanban")

	-- for save
	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "TextChangedP" }, {
		pattern = "<buffer=" .. task.buf_nr .. ">",
		callback = function()
			kanban.fn.tasks.save(kanban)
			kanban.fn.tasks.highlight(kanban, task)
		end,
	})

	-- for snippet
	vim.api.nvim_create_autocmd({ "TextChangedI", "TextChangedP" }, {
		pattern = "<buffer=" .. task.buf_nr .. ">",
		callback = function()
			kanban.fn.snip.popup(kanban)
		end,
	})
	vim.api.nvim_create_autocmd("InsertLeave", {
		pattern = "<buffer=" .. task.buf_nr .. ">",
		callback = function()
			vim.api.nvim_win_set_cursor(0, { 1, 0 })
			kanban.fn.snip.delete(kanban)
		end,
	})
end

return M
