local M = {}

function M.left(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	local focused_task = focused_list.tasks[focus.task_num]
	if focus.list_num == 1 then
	  return
	end
	local previous_list = kanban.items.lists[focus.task_num-1]

	M.fn.tasks.add(kanban, previous_list.title, task, "bottom")
end

function M.right(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	local focused_task = focused_list.tasks[focus.task_num]
	if focus.list_num == #kanban.items.lists then
	  return
	end

end
return M



