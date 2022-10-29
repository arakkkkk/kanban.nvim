local M = {}

local function get_cmp_due(kanban, line)
	-- today
	if string.match(line, "^@to?$") or string.match(line, "^@toda?$") or string.match(line, "^@today$") then
		return os.date("@%Y/%m/%d")
	-- 2d
	elseif string.match(line, "^@%d+d$") then
		local t = os.time()
		local d = string.gsub(line, "^@(%d+)d", "%1")
		t = t + d * 24 * 60 * 60
		return os.date("@%Y/%m/%d", t)
	-- 2w
	elseif string.match(line, "^@%d+w$") then
		local t = os.time()
		local d = string.gsub(line, "^@(%d+)w$", "%1")
		t = t + d * 7 * 24 * 60 * 60
		return os.date("@%Y/%m/%d", t)
	-- 2m
	elseif string.match(line, "^@%d+m$") then
		local t = os.date("*t")
		local m = string.gsub(line, "^@(%d+)m$", "%1")
		for _ = 1, tonumber(m) do
			if t.month == 12 then
				t.year = t.year + 1
			else
				t.month = t.month + 1
			end
		end
		return "@" .. t.year .. "/" .. t.month .. "/" .. t.day
	-- 2y
	elseif string.match(line, "^@%d+y$") then
		local t = os.date("*t")
		local y = string.gsub(line, "^@(%d+)y$", "%1")
		t.year = t.year + y
		return "@" .. t.year .. "/" .. t.month .. "/" .. t.day
	-- from month
	elseif string.match(line, "^@/%d%d/%d%d$") then
		local t = os.date("*t")
		local m = string.gsub(line, "^@/(%d%d)/%d%d$", "%1")
		local d = string.gsub(line, "^@/%d%d/(%d%d)$", "%1")
		return "@" .. t.year .. "/" .. m .. "/" .. d
	-- from day
	elseif string.match(line, "^@//%d%d$") then
		local t = os.date("*t")
		local d = string.gsub(line, "^@//(%d%d)$", "%1")
		return "@" .. t.year .. "/" .. t.month .. "/" .. d
	else
		return nil
	end
end

local function get_cmp_tag(kanban, line)
	line = string.lower(line)
	for i in pairs(kanban.items.lists) do
		local list = kanban.items.lists[i]
		for j in pairs(list.tasks) do
			for k in pairs(list.tasks[j].tag) do
				local tag = list.tasks[j].tag[k]
				local tag_lower = string.lower(tag)
				if string.match(tag_lower, "^" .. line .. ".+") then
					return tag
				end
			end
		end
	end
	return nil
end

function M.get_cmp(kanban)
	local l = vim.fn.line(".")
	local line = vim.fn.getline(l)
	if string.match(line, "^@.+") then
		return get_cmp_due(kanban, line)
	elseif string.match(line, "^#.+") then
		return get_cmp_tag(kanban, line)
	else
		return nil
	end
end
return M
