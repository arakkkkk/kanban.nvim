local M = {}

M.ops = require("kanban.ops").get_ops({})
M.fn = require("kanban.fn")
M.theme = require("kanban.theme")
M.active = false

function M.setup(options)
	M.ops = require("kanban.ops").get_ops(options)
	require("kanban.create_command").create_command(M)
	M.keymap = require("kanban.keymap").keymap
	vim.api.nvim_create_user_command("KanbanOpen", M.kanban_open, { nargs = "?" })
	M.theme.init(M)
	require("cmp").setup.filetype({ "kanban" }, {
		completion = {
			autocomplete = true,
		},
	})
end

function M.kanban_close(err, message)
	if message then
		print(message)
	end
	if err then
		vim.api.nvim_err_writeln(err)
	end
	M.active = false
end

function M.kanban_open(ops)
	local arg = ops.args
	if string.match(arg, "^%s*$") or arg == nil then
		vim.api.nvim_echo({ { "Please set argment [telescope or kanban file path]", "None" } }, false, {})
		return
	end

	if arg == "telescope" then
		local is_telescope_installed = pcall(require, "telescope")
		if not is_telescope_installed then
			vim.api.nvim_err_writeln("Telescope.nvim is not installed!!")
			return
		end
		local kanban_telescope = require("kanban.integrations.telescope").kanban_telescope
		kanban_telescope()
		return
	else
		M.kanban_md_path = arg
	end

	-- Check kanban activation
	if M.active then
		vim.api.nvim_err_writeln("kanban is already active!!")
		return
	else
		M.active = true
	end

	----------------------
	-- Read markdown
	----------------------
	M.markdown = require("kanban.markdown")
	local md = M.markdown.reader.read(M, M.kanban_md_path)
	if not md then
		return
	end

	-----------------------
	-- md to kanban
	-----------------------
	-- init
	M.kanban_title = md.kanban_title
	M.items = {}
	M.items.snip = {}
	M.items.kwindow = {}
	M.fn.kwindow.add(M) -- create window panel
	---- create list panel
	M.items.lists = {}
	for i in pairs(md.lists) do
		M.fn.lists.add(M, md.lists[i].title, false)
	end

	---- create task panel
	for i in pairs(md.lists) do
		local list = md.lists[i]
		for j in pairs(list.tasks) do
			local task = list.tasks[j]
			M.fn.tasks.add(M, i, task, "bottom")
		end
		if M.fn.tasks.utils.count_visible_tasks_in_list(M, i) == 0 then
			M.fn.tasks.add(M, i, nil, "bottom", true)
		end
	end
	---- Set default cursor position
	if #M.items.lists > 0 then
		for _, task in pairs(M.items.lists[1].tasks) do
			if task.win_id ~= nil then
				vim.fn.win_gotoid(task.win_id)
			end
		end
	end
end

return M
