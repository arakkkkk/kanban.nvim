local M = {}

function M.init()
	local hi_config = require("kanban.theme.hi_config")
	-- vim.api.nvim_set_hl(0, "NormalFloat", { fg = "None", bg = "None" })
	for i in pairs(hi_config) do
		local hc = hi_config[i]
		vim.fn.matchadd(hc.name, hc.pattern)
		vim.api.nvim_set_hl(0, hc.name, { fg = hc.fg, bg = hc.bg })
		print(hc.name)
	end
end

return M
