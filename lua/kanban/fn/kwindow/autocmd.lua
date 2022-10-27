local M = {}

function M.autocmd(kanban)
	vim.api.nvim_create_autocmd("BufWinLeave", {
		once = true,
		pattern = "<buffer=" .. kanban.items.kwindow.buf_nr .. ">",
		callback = function()
			kanban.fn.tasks.save(kanban)
			kanban.markdown.writer.write(kanban, kanban.kanban_md_path)
			kanban.active = false
		end,
	})
end

return M
