local M = {}

function M.read(kanban, md_path)
	local utils = require("kanban.utils")
	md_path = string.gsub(md_path, "^~", os.getenv("HOME"))
	local file_is_found = pcall(io.input, md_path)
	if not file_is_found then
		kanban.kanban_close(md_path .. " is not found ..")
		return
	end

	local md = {}
	md.lists = {}
	local list
	local task
	local in_frontmatter = false
	local in_settings = false

	while true do
		local lines = io.read()
		if lines == nil then
			break
		end

		for _, line in pairs(utils.split(lines, "<br>")) do
			local pat_list = "## (.*)"
			line = string.gsub(line, "^%s+", "")
			line = string.gsub(line, "%s+$", "")

			-- フロントマターの処理
			if line == "---" then
				in_frontmatter = not in_frontmatter
			elseif in_frontmatter then
				-- フロントマター内の場合は次の行へ
			elseif line == "%% kanban:settings" then
				in_settings = true
			elseif in_settings then
				if line == "%%" then
					in_settings = false
				end
			else
				if string.match(line, "^# .+$") then
					-- Remove header1
				elseif string.match(line, "^***$") then
					-- pass
				elseif string.match(line, "^%s*$") then
					-- blank line
				elseif string.match(line, "^" .. pat_list .. "$") then
					-- line is list
					local list_title = string.gsub(line, pat_list, "%1")
					-- create new list
					list = { title = list_title, tasks = {} }
					table.insert(md.lists, list)
				elseif string.match(line, "^- %[.%]") then
					task = kanban.fn.tasks.utils.create_blank_task(kanban)
					table.insert(list.tasks, task)
					-- create new task
					task.check = string.match(line, "^- %[x%]") ~= nil
					local content = string.match(line, "- %[.%] (.*)") or ""
					table.insert(task.lines, content)
				else
					-- line is task lines
					local content = string.match(line, "\t?(.*)")
					table.insert(task.lines, content)
				end
			end
		end
	end
	if #md.lists == 0 then
		vim.api.nvim_err_writeln(
			"No task data or Not kanban.vim file. \nPlease create kanban.nvim file by :KanbanCreate"
		)
		return false
	end
	io.close()
	return md
end

return M
