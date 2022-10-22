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
		row = M.options.layout.y_margin,
		col = M.options.layout.x_margin,
		width = vim.fn.winwidth(0) - M.options.layout.x_margin*2,
		height = vim.fn.winheight(0) - M.options.layout.y_margin*2,
		border = "rounded",
		style = "minimal",
		zindex = 1
	})
	-- create list panel
	M.panels.list = {}
	local count_list = require("kanban.utils").tablelength(M.markdown.list)
	local win_width = vim.fn.winwidth(0)
	local win_height = vim.fn.winheight(0)
	for _ , _ in pairs(M.markdown.list) do
		local buf_nr = vim.api.nvim_create_buf(false, "nomodeline")
		M.panels.list[#M.panels.list+1] = buf_nr
		vim.api.nvim_open_win(buf_nr, true, {
			relative = "editor",
			row = M.options.layout.y_margin + 4,
			col = M.options.layout.x_margin + ((win_width / count_list) * (#M.panels.list - 1)) + 2,
			width = (win_width / count_list) - 4,
			height = win_height - 6,
			border = "rounded",
			style = "minimal",
			zindex = 2 + #M.panels.list
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
