local M = {}

function M.write(kanban, md_path)
	local f = io.open(md_path, "w")
	assert(f)

	local list_head = kanban.ops.markdown.list_head
	local title_head = kanban.ops.markdown.title_head
	local title_style = kanban.ops.markdown.title_style
	local due_head = kanban.ops.markdown.due_head
	local due_style = kanban.ops.markdown.due_style
	local tag_head = kanban.ops.markdown.tag_head
	local tag_style = kanban.ops.markdown.tag_style

	-- Header
	for i in pairs(kanban.ops.markdown.header) do
		f:write(kanban.ops.markdown.header[i] .. "\n")
	end

	-- List
	for i in pairs(kanban.items.lists) do
		local list = kanban.items.lists[i]
		f:write("\n" .. list_head .. list.title .. "\n")
		-- Task
		for j in pairs(list.tasks) do
			local task = list.tasks[j]
			local title = title_head .. string.gsub(title_style, "<title>", task.title)
			f:write("\n" .. title .. "\n")
			-- Due
			for k in pairs(task.due) do
				local due = task.due[k]
				due = string.gsub(due, due_head, "")
				due = due_head .. string.gsub(due_style, "<due>", due)
				f:write(due .. "\n")
			end
			-- Tag
			for k in pairs(task.tag) do
				local tag = task.tag[k]
				tag = string.gsub(tag, tag_head, "")
				tag = tag_head .. string.gsub(tag_style, "<tag>", tag)
				f:write(tag .. "\n")
			end
		end
	end

	-- Footer
	for i in pairs(kanban.ops.markdown.footer) do
		f:write(kanban.ops.markdown.footer[i] .. "\n")
	end

end

return M