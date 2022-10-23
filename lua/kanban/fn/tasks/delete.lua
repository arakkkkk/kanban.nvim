local M = {}

function M.delete(kanban, task)
  local focus_win_id
  local remove_task_index
  for i in pairs(kanban.items.lists) do
    local is_focused_list = false
    local list = kanban.items.lists[i]
    for j in pairs(list.tasks) do
      if list.tasks[j].win_id == task.win_id then
        kanban.fn.tasks.close(list.tasks[j])
        remove_task_index = j
        if j > 1 then
          focus_win_id = list.tasks[j-1].win_id
        else
          focus_win_id = list.tasks[1].win_id
        end
        is_focused_list = true
      end
      if is_focused_list
        and j > 1
        and j ~= remove_task_index
        and list.tasks[j-1].win_id ~= nil
        and list.tasks[j].win_id == nil then
        kanban.fn.tasks.open(kanban, list.tasks[j])
        break
      end
    end
    if remove_task_index ~= nil then
      vim.fn.win_gotoid(focus_win_id)
      table.remove(list.tasks, remove_task_index);
      break
    end
  end
end

return M



