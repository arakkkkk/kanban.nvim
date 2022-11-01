local M = {}

function M.left(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	local focused_task = focused_list.tasks[focus.task_num]
	if focus.list_num == 1 then
		return
	end
	local clone_task = require("kanban.utils").deepcopy(focused_task)
	kanban.fn.tasks.delete(kanban)
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
	kanban.fn.tasks.delete(kanban)
	kanban.fn.tasks.add(kanban, focus.list_num + 1, clone_task, kanban.ops.move_position, true)
end

function M.up(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	local focused_task = focused_list.tasks[focus.task_num]
	if focus.task_num == 1 then
		return
	end
	local above_task = focused_list.tasks[focus.task_num - 1]
	focused_list.tasks[focus.task_num] = above_task
	focused_list.tasks[focus.task_num-1] = focused_task
	kanban.fn.tasks.resize(kanban, focus.list_num)
end

function M.down(kanban)
	local focus = kanban.fn.tasks.utils.get_focus(kanban)
	local focused_list = kanban.items.lists[focus.list_num]
	local focused_task = focused_list.tasks[focus.task_num]
	if focus.task_num == #focused_list.tasks then
		return
	end
	local below_task = focused_list.tasks[focus.task_num + 1]
	focused_list.tasks[focus.task_num] = below_task
	focused_list.tasks[focus.task_num+1] = focused_task
	kanban.fn.tasks.resize(kanban, focus.list_num)
end

return M
