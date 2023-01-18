local M = {}

M.ops = require("kanban.ops").get_ops({})
M.fn = require("kanban.fn")
M.theme = require("kanban.theme")
M.active = false

function M.setup(options)
	M.ops = require("kanban.ops").get_ops(options)
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
	require("kanban.user_command").del()
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
	local max_task_show_int = M.fn.tasks.utils.get_max_task_show_int(M)
	for i in pairs(md.lists) do
		local list = md.lists[i]
		if #list.tasks == 0 then
			M.fn.tasks.add(M, i, nil, "bottom", true)
		else
			for j in pairs(list.tasks) do
				local task = list.tasks[j]
				local open_bool = j <= max_task_show_int
				M.fn.tasks.add(M, i, task, "bottom", open_bool)
			end
		end
	end
	---- Set default cursor position
	if #M.items.lists > 0 then
		vim.fn.win_gotoid(M.items.lists[1].tasks[1].win_id)
	end
	require("kanban.user_command").create(M)
end

return M
