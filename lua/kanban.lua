local M = {}

function M.setup(options)
	M.ops = require("kanban.ops").get_ops(options)
	M.fn = require("kanban.fn")
	M.state = require("kanban.state").init()
	vim.api.nvim_create_user_command("Kanban", M.main, {})
end

function M.main()
	M.items = {}
	M.items.kwindow = {}
	local md = require("kanban.parser.parser").parser(M.ops)
	M.fn.kwindow.add(M)

	-- create list panel
	M.items.lists = {}
	for i in pairs(md.lists) do
		M.fn.lists.add(M, md.lists[i].title)
	end

	M.state.max_task_show_int = require("kanban.utils").get_show_task_int(M)

	-- create task panel
	for i in pairs(md.lists) do
		local list = md.lists[i]
		for j in pairs(list.tasks) do
			if j <= M.state.max_task_show_int then
				local task = list.tasks[j]
				M.fn.tasks.add(M, list.title, task)
			else
				break
			end
		end
	end
end

return M
