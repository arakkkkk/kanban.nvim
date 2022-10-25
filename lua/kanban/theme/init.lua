local M = {}

function M.init(kanban)
	local hi_config = kanban.ops.hl
	vim.api.nvim_set_hl(0, "NormalFloat", { fg = "None", bg = "None" })
	for i in pairs(hi_config) do
		local hc = hi_config[i]
		vim.api.nvim_set_hl(0, hc.name, hc.ops)
	end
end

return M
