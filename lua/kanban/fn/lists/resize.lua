local M = {}
function M.resize(kanban)
	local lists = kanban.items.lists
	for i in pairs(lists) do
	  lists[i].buf_conf.row = math.ceil(kanban.ops.layout.y_margin + 4)
	  lists[i].buf_conf.col = math.ceil(kanban.ops.layout.x_margin + ((kanban.items.kwindow.buf_conf.width / #lists) * (i - 1)) + 2)
	  lists[i].buf_conf.width = math.ceil((kanban.items.kwindow.buf_conf.width / #lists) - 4)
	  vim.api.nvim_win_set_config(lists[i].win_id, lists[i].buf_conf)
	end
end
return M

