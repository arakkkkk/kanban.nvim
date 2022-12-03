local M = {}

function M.read(kanban, md_path)
	local utils = require("kanban.utils")
	md_path = string.gsub(md_path, "^~", os.getenv("HOME"))
	pcall(io.input, md_path)
	local md = {}
	md.lists = {}
	local list
	local task
	while true do
		local lines = io.read()
		if lines == nil then
			break
		end

		for _, line in pairs(utils.split(lines, "<br>")) do
			local regexp = require("kanban.utils").to_regexp
			local list_head = kanban.ops.markdown.list_head
			local title_head = kanban.ops.markdown.title_head
			local title_style = kanban.ops.markdown.title_style
			local due_head = kanban.ops.markdown.due_head
			local due_style = kanban.ops.markdown.due_style
			local tag_head = kanban.ops.markdown.tag_head
			local tag_style = kanban.ops.markdown.tag_style
			local pat_head = list_head .. "(.*)"
			local pat_title = regexp(title_head) .. regexp(title_style)
			local pat_due = regexp(due_head) .. regexp(due_style)
			local pat_tag = regexp(tag_head) .. regexp(tag_style)

			-- List
			if string.match(line, "^" .. pat_head .. "$") then
				local list_title = string.gsub(line, pat_head, "%1")
				list = { title = list_title, tasks = {} }
				table.insert(md.lists, list)
			elseif string.match(line, "^" .. pat_title .. "$") then
				local title = string.gsub(line, pat_title, "%1")
				task = { title = title, tag = {}, due = {} }
				table.insert(list.tasks, task)
			elseif string.match(line, "^" .. pat_due .. "$") then
				local due = string.gsub(line, pat_due, due_head .. "%1")
				table.insert(task.tag, due)
			elseif string.match(line, "^" .. pat_tag .. "$") then
				print(line)
				local tag = string.gsub(line, pat_tag, tag_head .. "%1")
				table.insert(task.tag, tag)
			elseif line == "" then
				local _ = 1
			else
				vim.api.nvim_err_writeln("Unrecognized line!!\n" .. line)
			end
		end
	end
	io.close()
	return md
end

return M
