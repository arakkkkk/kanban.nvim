local M = {}
function M.popup(kanban)
	kanban.fn.snip.delete(kanban)
	local snip = kanban.items.snip

	snip.cmp = kanban.fn.snip.get_cmp(kanban)
	if snip.cmp == nil then
		return
	end
	snip.buf_nr = vim.api.nvim_create_buf(false, "nomodeline")

	vim.api.nvim_buf_set_lines(snip.buf_nr, 0, -1, true, { snip.cmp })

	local buf_conf = {
		relative = "cursor",
		row = 1,
		col = 0,
		width = 10,
		height = 1,
		style = "minimal",
		zindex = 100,
	}
	local win = vim.api.nvim_open_win(snip.buf_nr, false, buf_conf)
	vim.api.nvim_win_set_config(win, { width = #snip.cmp })

	vim.keymap.set("i", "<cr>", function()
		local l = vim.fn.line(".")
		vim.fn.setline(l, snip.cmp)
		vim.api.nvim_win_set_cursor(0, {l, #snip.cmp})
		-- vim.fn.append(l, "")
		-- vim.api.nvim_win_set_cursor(0, { l+1, 0 })
	end, { silent = true, buffer = vim.api.nvim_get_current_buf() })
end
return M
