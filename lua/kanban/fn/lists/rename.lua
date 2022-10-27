local M = {}

function M.rename(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]

	local list_title = vim.fn.input("New title -> ")
	kanban.items.lists[focus.list_num].title = list_title
	vim.fn.deletebufline(focused_list.buf_nr, 2)
	vim.fn.appendbufline(focused_list.buf_nr, 1, " " .. list_title)
end
return M
