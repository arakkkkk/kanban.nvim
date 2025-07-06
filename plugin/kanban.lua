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
