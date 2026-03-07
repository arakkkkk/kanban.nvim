local Utils = {}

function Utils.to_regexp(regrep)
	regrep = string.gsub(regrep, "%[", "%%[")
	regrep = string.gsub(regrep, "%]", "%%]")
	regrep = string.gsub(regrep, "%-", "%%-")
	regrep = string.gsub(regrep, "<.*>", "(.*)")
	return regrep
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

function Utils.TableConcat(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end
	return t1
end

function Utils.split(str, seq)
	local tab = {}
	while str ~= "" do
		local fc = string.find(str, seq)
		if fc == nil then
			table.insert(tab, str)
			break
		end
		table.insert(tab, str.sub(str, 1, fc - 1))
		str = string.sub(str, fc + #seq)
	end
	return tab
end

function Utils.includes(table, str)
	for i in pairs(table) do
		if table[i] == str then
			return true
		end
	end
	return false
end

function Utils.file_exists(path)
	local fh = io.open(path, "rb")
	if fh then
		fh:close()
	end
	return fh ~= nil
end

---Check the user provided default_lists for any errors. 
---Return both a properly formatted list of valid entries and, separately, any invalid entries.
---
---@param default_lists string[] | {title: string, tasks: table?}[] 
---@return {title: string, tasks: table?}[]
---@return table | string
function Utils.check_lists(default_lists)
	if type(default_lists) ~= "table" then
		-- If default_lists is not a table, 
		return {}, string.format(
			"default_lists is type %s not table",
			tostring(type(default_lists))
		)
	end
	local formatted_entries = {}
	local bad_entries = {}
	for i, v in ipairs(default_lists) do
		if type(v) == "string" then
			formatted_entries[i] = {title = v, tasks={}}
		elseif type(v) == "table" then
			if not v["title"] then
				-- Invalid entry as no title present
				bad_entries[i] = v
			else
				if not v["tasks"] then
					-- Title present but no tasks
					local entry = v
					entry["tasks"] = {}
					formatted_entries[i] = entry
				else
					-- Tasks are present
					-- Don't currently check for validity of tasks (TODO?)
					formatted_entries[i] = v
				end
			end
		else
			bad_entries[i] = v
		end
	end
	return formatted_entries, bad_entries
end
return Utils
