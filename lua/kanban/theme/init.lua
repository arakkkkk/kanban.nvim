local M = {}

function M.init(kanban)
	local hi_config = kanban.ops.hl
	for i in pairs(hi_config) do
		local hc = hi_config[i]
		vim.api.nvim_set_hl(0, hc.name, hc.ops)
	end
end

return M
