local M = {}
-- local utils = require("kanban.utils")
-- local function req(file_name)
--   return require("kanban.ops" .. file_name)
-- end

function M.setup_ops_laytout(options)
	return {
		x_margin = options.x_margin or 5,
		y_margin = options.y_margin or 3,
	}
end

function M.setup_ops_markdown(options)
	return {
		-- x_margin = options.x_margin or 10,
		-- y_margin = options.y_margin or 6,
		-- list_width = options.list_width or 40,
	}
end

function M.setup_ops(options)
	local ops = {}
	ops.layout = M.setup_ops_laytout(options)
	ops.markdown = M.setup_ops_markdown(options)
	return ops
end


return M

