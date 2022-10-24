local M = {}
M.utils = {}

function M.get_focus(kanban)
  for i in pairs(kanban.items.lists) do
    local list = kanban.items.lists[i]
    for j in pairs(list.tasks) do
      local task = list.tasks[j]
      if vim.fn.win_getid() == task.win_id then
        return {list_num = i, task_num = j}
      end
    end
  end
  assert(false)
end

return M

