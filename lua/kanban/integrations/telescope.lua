local M = {}
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

function M.kanban_picker_telescope(kanban)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values

	local files = vim.fn.globpath(kanban.ops.board_path, "**/*.md", true, true)
	if vim.tbl_isempty(files) then
		vim.notify("No kanban boards found in " .. kanban.ops.board_path, vim.log.levels.WARN)
		return
	end

	pickers
		.new({
			prompt_title = "Kanban Boards",
			finder = finders.new_table({
				results = files,
				entry_maker = function(entry)
					return {
						value = entry,
						display = vim.fn.fnamemodify(entry, ":~:."),
						ordinal = vim.fn.fnamemodify(entry, ":~:."),
					}
				end,
			}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					require("kanban").kanban_open(selection.value)
				end)
				return true
			end,
			sorter = conf.generic_sorter({}),
		})
		:find()
end

M.kanban_telescope = function(opts)
	local handle = io.popen("rg '\-+[
\s]+kanban-plugin: .+[\n\s]+\-+' -lU ./")
	assert(handle)
	local io_output = handle:read("*a")
	local paths = {}

	for line in io_output:gmatch("([^
]*)
?") do
		if line ~= "" then
			table.insert(paths, line)
		end
	end
	handle:close()

	opts = opts or {}
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	pickers
		:new(opts, {
			prompt_title = "Kanban.nvim",
			finder = finders.new_table({
				results = paths,
			}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					vim.cmd("KanbanOpen " .. selection[1])
				end)
				return true
			end,
			sorter = conf.generic_sorter(opts),
		})
		:find()
end

return M