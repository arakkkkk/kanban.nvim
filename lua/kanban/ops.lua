local M = {}

function M.get_ops_laytout(options)
	return {
		x_margin = options.x_margin or 5,
		y_margin = options.y_margin or 3,
		task_height = options.task_height or 3,
	}
end

function M.get_ops_markdown(options)
	return {
		-- x_margin = options.x_margin or 10,
		-- y_margin = options.y_margin or 6,
		-- list_width = options.list_width or 40,
	}
end

function M.get_ops(options)
	local ops = {}
	ops.layout = M.get_ops_laytout(options)
	ops.markdown = M.get_ops_markdown(options)
	-- ops.add_position = options.add_position or "bottom"
	ops.move_position = options.move_position or "top"
	return ops
end


return M
