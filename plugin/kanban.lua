if vim.fn.has("nvim-0.7.0") == 0 then
	vim.api.nvim_err_writeln("kanban requires at least nvim-0.7.0.1")
	return
end

-- make sure this file is loaded only once
if vim.g.loaded_kanban == 1 then
	return
end
vim.g.loaded_kanban = 1

if pcall(require, "obsidian") then
	require("obsidian").register_command("kanban", {
		nargs = "+",
		note_action = true,
		complete = function(_, _, _)
			return { "open", "create" }
		end,
	})
end

-- Auto integrate with nvim-cmp when available
local function try_setup_cmp()
	local ok_cmp = pcall(require, "cmp")
	if not ok_cmp then
		return
	end
	local ok_mod, cmp_mod = pcall(require, "kanban.fn.cmp.nvim-cmp")
	if not ok_mod then
		return
	end
	local ok_kanban, kanban = pcall(require, "kanban")
	if not ok_kanban then
		return
	end
	pcall(cmp_mod.setup, kanban)
end

-- 1) 起動時にcmpが既にあれば登録
try_setup_cmp()

-- 2) kanbanファイルを開いたタイミングでも再試行（lazy-load対策）
vim.api.nvim_create_autocmd("FileType", {
	pattern = "kanban",
	callback = function()
		try_setup_cmp()
	end,
})
