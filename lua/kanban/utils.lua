local Utils = {}

function Utils.buf_delete(kanban)
  local list = kanban.panels.list

  local function bd(n)
    vim.cmd.bdelete(n)
  end

  for i = 1 , #list do
    pcall(bd, list[i])
  end
end


return Utils
