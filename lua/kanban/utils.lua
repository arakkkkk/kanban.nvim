local Utils = {}

function Utils.to_regexp(regrep)
	regrep = string.gsub(regrep, "%[", "%%[")
	regrep = string.gsub(regrep, "%]", "%%]")
	-- regrep = string.gsub(regrep, "%}", "%%}")
	-- regrep = string.gsub(regrep, "%{", "%%}")
	regrep = string.gsub(regrep, "<.*>", "(.*)")
	return regrep
end

function Utils.buf_delete(kanban)
	local list = kanban.items.list

	local function bd(n)
		vim.cmd.bdelete(n)
	end

	for i = 1, #list do
		pcall(bd, list[i])
	end
	pcall(vim.cmd.bdelete, kanban.items.kwindow)
end

function Utils.tablelength(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

function Utils.deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		-- tableなら再帰でコピー
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[Utils.deepcopy(orig_key)] = Utils.deepcopy(orig_value)
		end
		setmetatable(copy, Utils.deepcopy(getmetatable(orig)))
	else
		-- number, string, booleanなどはそのままコピー
		copy = orig
	end
	return copy
end

function Utils.tableMerge(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" then
			if type(t1[k] or false) == "table" then
				Utils.tableMerge(t1[k] or {}, t2[k] or {})
			else
				t1[k] = v
			end
		else
			t1[k] = v
		end
	end
	return t1
end

return Utils
