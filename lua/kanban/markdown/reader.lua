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
	while true do
		local lines = io.read()
		if lines == nil then
			break
		end

		for _, line in pairs(utils.split(lines, "<br>")) do
			local regexp = require("kanban.utils").to_regexp
			local list_head = kanban.ops.markdown.list_head
			local title_style = kanban.ops.markdown.title_style
			local due_head = kanban.ops.markdown.due_head
			local due_style = kanban.ops.markdown.due_style
			local tag_head = kanban.ops.markdown.tag_head
			local tag_style = kanban.ops.markdown.tag_style
			local pat_head = list_head .. "(.*)"
			local pat_due = regexp(due_head) .. regexp(due_style)
			local pat_tag = regexp(tag_head) .. regexp(tag_style)
			line = string.gsub(line, "^%s+", "")
			line = string.gsub(line, "%s+$", "")

			is_archived = false

			if string.match(line, "^# .+$") then
				-- Remove header1
			if string.match(line, "^***$") then

			elseif string.match(line, "^" .. pat_head .. "$") then
				local list_title = string.gsub(line, pat_head, "%1")
				list = { title = list_title, tasks = {} }
				table.insert(md.lists, list)
			elseif string.match(line, "^- %[.%] .+$") then
				task = kanban.fn.tasks.utils.create_blank_task(kanban)
				-- Extract title
				task.title = string.gsub(line, "^- %[.%] ", "")
			 	task.check	= line:match("^- %[(.)%]")
				table.insert(list.tasks, task)
			elseif string.match(line, "^" .. pat_due .. "$") then
				local due = string.gsub(line, pat_due, due_head .. "%1")
				table.insert(task.due, due)
			elseif string.match(line, "^" .. pat_tag .. "$") then
				local tag = string.gsub(line, pat_tag, tag_head .. "%1")
				table.insert(task.tag, tag)
			elseif line == "" then
				local _ = 1
			elseif utils.includes(kanban.ops.markdown.header, line) then
				local _ = 1
			elseif utils.includes(kanban.ops.markdown.footer, line) then
				local _ = 1
			else
				vim.api.nvim_err_writeln("Unrecognized line!!     \n" .. line)
				return false
			end
		end
	end
	if #md.lists == 0 then
		vim.api.nvim_err_writeln("No task data or Not kanban.vim file. \nPlease create kanban.nvim file by :KanbanCreate")
		return false
	end
	io.close()
	return md
end

return M
