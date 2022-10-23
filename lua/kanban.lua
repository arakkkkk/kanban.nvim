local M = {}

function M.setup(options)
	M.ops = require("kanban.ops").get_ops(options)
	M.fn = require("kanban.fn")
	M.state = require("kanban.state").init(M)
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

	-- create task panel
	for i in pairs(md.lists) do
		local list = md.lists[i]
		for j in pairs(list.tasks) do
			local task = list.tasks[j]
			M.fn.tasks.add(M, list.title, task)
			if j <= M.state.max_task_show_int then
				M.fn.tasks.open(M, task)
			end
		end
	end

end

return M
