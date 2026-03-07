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
			if pcall(require, "telescope") then
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

	M.theme.init(M)
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
	path = path:match("%.md$") and path or path .. ".md"
	local markdown = require("kanban.markdown")
	if require("kanban.utils").file_exists(path) then
		vim.notify(path .. " already exists!", vim.log.levels.ERROR)
		return
	end
	M.items = {}
	local preset_list = {
		{ title = "TODO", tasks = {} },
		{ title = "Work in progress", tasks = {} },
		{ title = "Done", tasks = {} },
		{ title = "Archive", tasks = {} },
	}
	if M.ops.markdown.default_lists then
		local err = nil
		local formatted_list = nil
		-- Check the format of the lists
		-- Returns all valid entries in the proper format in the first return variable
		-- Returns any errors as an array and ignores them, or if the input is completely
		-- wrong it will return as a string and error out
		formatted_list, err = require("kanban.utils").check_lists(M.ops.markdown.default_lists)
		if type(err) == "string" then
			-- The error is a string if the default_lists parameter is not a table
			-- Raise an error, do not create a file
			vim.notify(err, vim.log.levels.ERROR)
			return
		else
			-- If some of the inputs are incorrect, raise a warning for each incorrect entry with the index
			-- Create the file, excluding the bad values
			for i, _ in pairs(err) do
				local msg = ("Improper input for default_lists at index " .. tostring(i))
				vim.notify(msg, vim.log.levels.WARN)
			end
		end
		-- Count number of valid entries
		local count = 0
		for _ in pairs(formatted_list) do count = count + 1 end
		if count < 1 then
			-- If no valid entries for default_list, count will be zero
			-- Raise an error, do not create a file
			vim.notify("No valid entries in default_lists", vim.log.levels.ERROR)
			return
		end
		M.items.lists = formatted_list
	else
		-- If default_list is not specified by the user, use the preset one
		M.items.lists = preset_list
	end
	markdown.writer.write(M, path)
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
		vim.notify("KanbanOpen requires 1 argument.", vim.log.levels.ERROR)
		return
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
		M.kanban_md_path = arg
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
