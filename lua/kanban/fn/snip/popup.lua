local M = {}
function M.popup(kanban)
	local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.fn.getline(r)
	local snip = kanban.items.snip
	if snip == nil then
		snip = {}
	else
		kanban.fn.snip.delete(kanban)
	end

	if string.match(line, "^@.+") then
		snip.list = kanban.fn.snip.list_snip.due(kanban, line)
	elseif string.match(line, "^#.+") then
		snip.list = kanban.fn.snip.list_snip.tag(kanban, line)
	else
		return
	end
	snip.buf_nr = vim.api.nvim_create_buf(false, "nomodeline")
	vim.api.nvim_buf_set_lines(snip.buf_nr, r - 1, -1, true, snip.list)

	local buf_conf = {
		relative = "cursor",
		row = 1,
		col = 0,
		width = 10,
		height = 5,
		style = "minimal",
		zindex = 40,
	}
	vim.api.nvim_open_win(snip.buf_nr, false, buf_conf)
	kanban.items.snip = snip
end
return M
