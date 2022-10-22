local M = {}

function M.setup(options)
	M.options = require("kanban.config").get_ops(options)
	M.markdown = require("kanban.parser.parser").parse(M.options)
	vim.api.nvim_create_user_command("Kanban", M.main, {})
end

function M.main()

	M.panels = {}
	-- create kanban panel
	M.panels.kanban = vim.api.nvim_create_buf(false, "nomodeline")
	vim.api.nvim_open_win(M.panels.kanban, true, {
		relative = "win",
		row = M.options.layout.y_margin / 2,
		col = M.options.layout.x_margin / 2,
		width = vim.fn.winwidth(0) - M.options.layout.x_margin,
		height = vim.fn.winheight(0) - M.options.layout.y_margin,
		border = "rounded",
		style = "minimal",
		zindex = 1
	})
	-- create list panel
	for i = 1 , #M.panels.list do
		M.panels.list = {}
		M.panels.list[#M.panels.list+1] = vim.api.nvim_create_buf(false, "nomodeline")
		vim.api.nvim_open_win(M.panels.list, true, {
			relative = "win",
			row = M.options.layout.y_margin / 2,
			col = M.options.layout.x_margin / 2,
			width = vim.fn.winwidth(0) - M.options.layout.x_margin,
			height = vim.fn.winheight(0) - M.options.layout.y_margin,
			border = "rounded",
			style = "minimal",
			zindex = 1
		})
	end

  vim.api.nvim_create_autocmd("BufLeave", {
    once = true,
    callback = function()
    	require("kanban.utils").buf_delete(M)
    end,
  })

end

return M
