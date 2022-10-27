local M = {}

function M.delete(kanban)
  local focus = kanban.fn.tasks.utils.get_focus(kanban)
  local focused_list = kanban.items.lists[focus.list_num]
	kanban.fn.lists.close(focused_list)
	kanban.fn.lists.resize(kanban)
	vim.fn.win_gotoid(focused_list.win_id)
end

return M
