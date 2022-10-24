local M = {}

function M.get_ops_laytout(options)
	if options.layout == nil then
		options.layout = {}
	end
	return {
		x_margin = options.layout.x_margin or 5,
		y_margin = options.layout.y_margin or 3,
		task_height = options.layout.task_height or 3,
	}
end

function M.get_ops_markdown(options)
	if options.markdown == nil then
		options.markdown = {}
	end
	return {
		list = options.markdown.list or "## <list>",
		title = options.markdown.title or "- [ ] [[<title>]]",
		due = options.markdown.due or "@{<due>}",
		tag = options.markdown.tag or "#<tag>",
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
