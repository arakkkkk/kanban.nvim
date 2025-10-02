local M = {}

M.ops = require("kanban.ops").get_ops({})
M.fn = require("kanban.fn")
M.theme = require("kanban.theme")
M.active = false

function M.setup(options)
	M.ops = require("kanban.ops").get_ops(options)
	M.keymap = require("kanban.keymap").keymap
	vim.api.nvim_create_user_command("KanbanOpen", function(opts)
		M.kanban_open(opts.fargs[1])
	end, {
		nargs = "?",
		complete = function(_, _, _)
			local paths = {}
			if pcall(require, "obsidian") then
				table.insert(paths, "telescope")
			end
			local handle = io.popen("rg '\\-+[\\n\\s]+kanban-plugin: .+[\\n\\s]+\\-+' -lU ./")
			if not handle then
				return {}
			end
			local io_output = handle:read("*a")
			for line in io_output:gmatch("([^\n]*)\n?") do
				if line ~= "" then
					table.insert(paths, line)
				end
			end
			return paths
		end,
	})
	vim.api.nvim_create_user_command("KanbanCreate", function(opts)
		M.kanban_create(opts.fargs[1])
	end, {
		nargs = 1,
		complete = function(arg, _, _)
			local arg_path = arg:match("(.+)/[^/]*$") or ""
			local arg_tail = arg:match("[^/]*$")
			local handle = io.popen("find ./" .. arg_path .. " -name '" .. arg_tail .. "*' -type d")
			-- print("find ./" .. arg_path .. " -name '" .. arg_tail .. "' -type d")
			if not handle then
				return {}
			end
			local io_output = handle:read("*a")
			-- print(io_output)
			local paths = {}
			for line in io_output:gmatch("([^\n]*)\n?") do
				if line and line ~= "" then
					line = line:gsub("^[%./]+/", "")
					if line ~= "" and not line:match("^%.") then
						table.insert(paths, line)
					end
				end
			end
			return paths
		end,
	})
	vim.api.nvim_create_user_command("KanbanPicker", function()
		M.picker()
	end, {
		nargs = 0,
		desc = "Open a kanban board from a list of available boards",
	})

	M.theme.init(M)
end

function M.picker()
	local files = vim.fn.globpath(M.ops.board_path, "**/*.md", true, true)
	if vim.tbl_isempty(files) then
		vim.notify("No kanban boards found in " .. M.ops.board_path, vim.log.levels.WARN)
		return
	end

	local filtered_files = vim.tbl_filter(function(file)
		local filename = vim.fn.fnamemodify(file, ":t")
		return not vim.startswith(filename, "tasks")
	end, files)

	vim.ui.select(filtered_files, {
		prompt = "Select a Kanban board:",
		format_item = function(item)
			return vim.fn.fnamemodify(item, ":t")
		end,
	}, function(choice)
		if not choice then
			return
		end
		M.kanban_open(choice)
	end)
end

function M.kanban_close(err, message)
	if message then
		print(message)
	end
	if err then
		vim.notify(err, vim.log.levels.ERROR)
	end
	M.active = false
	require("kanban.user_command").del()
end

function M.kanban_create(path)
	vim.fn.mkdir(M.ops.board_path, "p")
	local full_path = M.ops.board_path .. path
	full_path = full_path:match("%.md$") and full_path or full_path .. ".md"

	local markdown = require("kanban.markdown")
	if require("kanban.utils").file_exists(full_path) then
		vim.notify(full_path .. " already exists!", vim.log.levels.ERROR)
		return
	end
	M.items = {}
	M.items.lists = {
		{ title = "TODO", tasks = {} },
		{ title = "Work in progress", tasks = {} },
		{ title = "Done", tasks = {} },
		{ title = "Archive", tasks = {} },
	}
	markdown.writer.write(M, full_path)
	vim.notify("Created kanban board at " .. full_path)
end

function M.kanban_open(arg)
	-- Check kanban activation
	if M.active then
		vim.notify("kanban is already active!!", vim.log.levels.ERROR)
		return
	else
		M.active = true
	end

	----------------------
	-- Read markdown from current buffer
	----------------------
	-- When no file is specified, use the current buffer as the target
	if arg == nil then
		M.kanban_md_path = vim.fn.expand("%:p")
	elseif arg == "telescope" then
		local is_telescope_installed = pcall(require, "telescope")
		if not is_telescope_installed then
			vim.notify("Telescope.nvim is not installed!!", vim.log.levels.ERROR)
			return
		end
		local kanban_telescope = require("kanban.integrations.telescope").kanban_telescope
		kanban_telescope()
		return
	else
		-- Handle absolute paths from picker vs relative paths from command
		if arg:match("^/") or arg:match("^~") then
			M.kanban_md_path = arg
		else
			local local_path = vim.fn.expand("./") .. arg
			if not local_path:match("%.md$") then
				local_path = local_path .. ".md"
			end

			if vim.fn.filereadable(local_path) == 1 then
				M.kanban_md_path = local_path
			else
				M.kanban_md_path = M.ops.board_path .. arg
				if not M.kanban_md_path:match("%.md$") then
					M.kanban_md_path = M.kanban_md_path .. ".md"
				end
			end
		end
	end

	----------------------
	-- Read markdown file
	----------------------
	M.markdown = require("kanban.markdown")
	local md = M.markdown.reader.read(M, M.kanban_md_path)
	if not md then
		M.active = false
		return
	end

	-----------------------
	-- md to kanban
	-----------------------
	-- init
	M.items = {}
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
