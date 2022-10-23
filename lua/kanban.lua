local M = {}

function M.setup(options)
	M.ops = require("kanban.ops").get_ops(options)
	M.fn = require("kanban.fn")
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
end

return M
