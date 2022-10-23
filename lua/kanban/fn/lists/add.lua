local M = {}
-- Absolute path
function M.add(kanban, title)
	local lists = kanban.items.lists

	lists[#lists+1] = {
	  title = title,
	}
	lists[#lists].buf_nr = vim.api.nvim_create_buf(false, "nomodeline")
	vim.api.nvim_buf_set_lines(lists[#lists].buf_nr, 0, -1, true, {title})

	lists[#lists].buf_conf = {
		relative = "editor",
	  row = 10,
	  col = 12 + #lists,
	  width = 10,
		height = kanban.items.kwindow.buf_conf.height - 6,
		border = "rounded",
		style = "minimal",
		zindex = 2 + #lists
	}

	lists[#lists].win_id = vim.api.nvim_open_win(lists[#lists].buf_nr, true, lists[#lists].buf_conf)

  kanban.fn.lists.resize(kanban)

  vim.api.nvim_create_autocmd("BufWinLeave", {
    once = true,
    callback = function()
      kanban.fn.lists.close(kanban)
    end,
  })
end
return M



