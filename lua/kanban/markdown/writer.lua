local M = {}

function M.write(kanban, md_path)
	md_path = string.gsub(md_path, "^~", os.getenv("HOME"))

	local lines = {}

	-- Header
	for i in pairs(kanban.ops.markdown.header) do
		table.insert(lines, kanban.ops.markdown.header[i])
	end

	-- List
	for i in pairs(kanban.items.lists) do
		local list = kanban.items.lists[i]
		table.insert(lines, "")
		table.insert(lines, "## " .. list.title)
		table.insert(lines, "")
		-- Task
		for j in pairs(list.tasks) do
			local task = list.tasks[j]
			for k in pairs(task.lines) do
				local line = task.lines[k]
				if k == 1 then
					-- is first line
					if task.check then
						line = "- [x] " .. line
					else
						line = "- [ ] " .. line
					end
				else
					line = "\t" .. line
				end
				table.insert(lines, line)
			end
		end
	end

	-- Footer
	table.insert(lines, "")
	for i in pairs(kanban.ops.markdown.footer) do
		table.insert(lines, kanban.ops.markdown.footer[i])
	end

	local f = io.open(md_path, "w")
	if f == nil then
		vim.api.nvim_err_writeln("Error: can't open file!!    " .. md_path)
		return
	end
	for i in pairs(lines) do
		f:write(lines[i] .. "\n")
	end
	f:close()

	vim.api.nvim_echo({ { "kanban saved!!", "None" } }, false, {})
end

return M
