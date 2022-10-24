local M = {}

function M.setup(options)
	M.ops = require("kanban.ops").get_ops(options)
	M.state = require("kanban.state").init(M)
	M.fn = require("kanban.fn")
	M.parser = require("kanban.parser")
	vim.api.nvim_create_user_command("Kanban", M.main, {})
end

function M.main()
	M.items = {}
	M.items.kwindow = {}
	local md = M.parser.parse(M.ops)
	M.fn.kwindow.add(M)

	-- create list panel
	M.items.lists = {}
	for i in pairs(md.lists) do
		M.fn.lists.add(M, md.lists[i].title)
	end

	-- create task panel
	for i in pairs(md.lists) do
		local list = md.lists[i]
		for j in pairs(list.tasks) do
			local task = list.tasks[j]
			local open_bool = j <= M.state.max_task_show_int
			M.fn.tasks.add(M, i, task, "bottom", open_bool)
		end
	end
	vim.fn.win_gotoid(M.items.lists[1].tasks[1].win_id)


end

return M
