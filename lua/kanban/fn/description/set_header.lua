local M = {}

local function write_title(task, insert)
	vim.fn.setline(1, "# " .. task.lines[1])
end
local function write_tag(task, insert)
	local tags = ""
	for _, line in ipairs(task.lines) do
		-- gmatch を使って全ての #単語 を抽出
		for tag in line:gmatch("#%w+") do
			tags = tags .. tag
		end
	end
	vim.fn.setline(2, "tag:" .. tags)
end
local function write_due(task, insert)
	local due = ""
	for _, line in ipairs(task.lines) do
		-- gmatch を使って全ての #単語 を抽出
		for _due in line:gmatch("@[^%s]+") do
			due = _due
			break
		end
	end
	vim.fn.setline(3, "due: " .. due)
end
local function write_created(task, insert)
	vim.fn.setline(4, "created: " .. os.date("%Y/%m/%d"))
end
local function write_updated(task, insert)
	vim.fn.setline(5, "updated: " .. os.date("%Y/%m/%d"))
end

function M.set_header(kanban)
	local description = kanban.items.description
	local task = description.task

	local current_buf = vim.api.nvim_get_current_buf()
	local doc_lines = vim.fn.getbufline(current_buf, 1, "$")

	if #doc_lines == 1 and doc_lines[1] == "" then
		write_title(task, false)
		write_tag(task, false)
		write_due(task, false)
		write_created(task, false)
		-- write_updated(task, false)
	end
end

return M
