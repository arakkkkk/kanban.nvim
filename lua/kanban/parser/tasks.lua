local M = {}

function M.parser(ops, lists)
	local tasks = {
		{ title = "11111111111", tag = {"#tag"}, due = {"@yyyy/mm/dd"} },
		{ title = "22222222222", tag = {"#tag"}, due = {"@yyyy/mm/dd"} },
		{ title = "33333333333", tag = {"#tag"}, due = {"@yyyy/mm/dd"} },
		-- { title = "44444444444", tag = "#tag", due = "@yyyy/mm/dd" },
		-- { title = "55555555555", tag = "#tag", due = "@yyyy/mm/dd" },
		-- { title = "66666666666", tag = "#tag", due = "@yyyy/mm/dd" },
		-- { title = "77777777777", tag = "#tag", due = "@yyyy/mm/dd" },
		-- { title = "88888888888", tag = "#tag", due = "@yyyy/mm/dd" },
		-- { title = "99999999999", tag = "#tag", due = "@yyyy/mm/dd" },
		-- { title = "aaaaaaaaaaa", tag = "#tag", due = "@yyyy/mm/dd" },
		-- { title = "bbbbbbbbbbb", tag = "#tag", due = "@yyyy/mm/dd" },
		-- { title = "ccccccccccc", tag = "#tag", due = "@yyyy/mm/dd" },
		-- { title = "ddddddddddd", tag = "#tag", due = "@yyyy/mm/dd" },
		-- { title = "eeeeeeeeeee", tag = "#tag", due = "@yyyy/mm/dd" },
	}
	return tasks
end

return M

