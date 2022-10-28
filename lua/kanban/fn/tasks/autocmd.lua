local M = {}

function M.autocmd(kanban, task)
	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "TextChangedP" }, {
		pattern = "<buffer=" .. task.buf_nr .. ">",
		callback = function()
			kanban.fn.tasks.save(kanban)
			kanban.fn.tasks.highlight(kanban, task)
		end,
	})
end

return M
