local M = {}

function M.left(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	local focused_task = focused_list.tasks[focus.task_num]
	if focus.list_num == 1 then
		return
	end
	local clone_task = require("kanban.utils").deepcopy(focused_task)
	kanban.fn.tasks.delete(kanban, focused_task)
	kanban.fn.tasks.add(kanban, focus.list_num - 1, clone_task, kanban.ops.move_position, true)
end

function M.right(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	local focused_task = focused_list.tasks[focus.task_num]
	if focus.list_num == #kanban.items.lists then
		return
	end
	local clone_task = require("kanban.utils").deepcopy(focused_task)
	kanban.fn.tasks.delete(kanban, focused_task)
	kanban.fn.tasks.add(kanban, focus.list_num + 1, clone_task, kanban.ops.move_position, true)
end
return M
