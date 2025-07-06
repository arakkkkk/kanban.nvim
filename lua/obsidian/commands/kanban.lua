local kanban = require("kanban")
return function(_, data)
	local method = data.fargs[1]
	local arg = data.fargs[2]
	if method == "create" then
		if arg == nil then
			error("An additional argument is required.")
		end
		kanban.kanban_create(arg)
	elseif method == "open" then
		kanban.kanban_open(arg)
	end
end
