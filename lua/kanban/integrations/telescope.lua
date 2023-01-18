M = {}
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")

M.kanban_telescope = function(opts)
	local handle = io.popen("rg '\\-+[\n\\s]+kanban-plugin: .+[\\n\\s]+\\-+' -lU ./")
	assert(handle)
	local io_output = handle:read("*a")
	local paths = {}
	for line in io_output:gmatch("([^\n]*)\n?") do
		if line ~= "" then
			table.insert(paths, line)
		end
	end
	handle:close()

	opts = opts or {}
	pickers
		.new(opts, {
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
