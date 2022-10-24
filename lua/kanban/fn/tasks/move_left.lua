local M = {}

function M.move_left(kanban, task)
  local selected_row_int
  for i in pairs(kanban.items.lists) do
    local list = kanban.items.lists[i]
    local prev_list = kanban.items.lists[i-1]
    selected_row_int = 0
    for j in pairs(list.tasks) do
      if list.tasks[j].win_id ~= nil then
        selected_row_int = selected_row_int + 1
      end
      if list.tasks[j].win_id == task.win_id then
        if i > 1 then
          local notnil_count = 0
          for k in pairs(prev_list.tasks) do
            if prev_list.tasks[k].win_id ~= nil then
              notnil_count = notnil_count + 1
              if notnil_count == selected_row_int or
                k == prev_list.tasks then
                vim.fn.win_gotoid(prev_list.tasks[k].win_id)
                break
              end
            end
            vim.fn.win_gotoid(prev_list.tasks[#prev_list.tasks].win_id)
          end
        end
      end
    end
  end
  return selected_row_int
end

return M

