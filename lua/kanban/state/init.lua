local M = {}

function M.init(kanban)
	local function get_max_task_show_int(K)
		local list_heihgt = vim.fn.winheight(0) - kanban.ops.layout.y_margin * 2 - 6
		local task_area_height = list_heihgt - 4 - 2
		local task_height = K.ops.layout.task_height + 2
		local show_task_height = task_area_height / task_height
		return show_task_height + 1
	end

	return {
		max_task_show_int = get_max_task_show_int(kanban),
	}
end

return M
