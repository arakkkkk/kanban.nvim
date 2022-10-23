local Utils = {}

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

return Utils
