local M = {}

function M.take_left(kanban, task)
  for i in pairs(kanban.items.lists) do
    local list = kanban.items.lists[i]
    local prev_list = kanban.items.lists[i-1]
    for j in pairs(list.tasks) do
      local a=2

    end
  end
end

return M


