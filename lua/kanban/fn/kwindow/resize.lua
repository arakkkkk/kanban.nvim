local M = {}
function M.resize(kanban)
	local lists = kanban.items.lists
	local count_list = require("kanban.utils").tablelength(lists)
	for i in pairs(lists) do
	  lists[i].buf_conf.row = kanban.ops.layout.y_margin + 4
	  lists[i].buf_conf.col = kanban.ops.layout.x_margin + ((kanban.items.kwindow.buf_conf.width / count_list) * (i - 1)) + 2
	  lists[i].buf_conf.width = (kanban.items.kwindow.buf_conf.width / count_list) - 4
	  vim.api.nvim_win_set_config(lists[i].win_id, lists[i].buf_conf)
	end
end
return M

