local M = {}

function M.move_up(kanban, task)
  for i in pairs(kanban.items.lists) do
    local list = kanban.items.lists[i]
    for j in pairs(list.tasks) do
      if list.tasks[j].win_id == task.win_id then
        local above_task = list.tasks[j-1]
        -- Up without scroll
        if j > 1 and above_task.win_id ~= nil then
          vim.fn.win_gotoid(above_task.win_id)
        -- Up with scroll
        elseif j > 1 and above_task.win_id == nil then
          -- Close foot task window (above nil window)
          for k = j, #list.tasks do
            if list.tasks[k].win_id == nil or k == #list.tasks then
              kanban.fn.tasks.close(list.tasks[k-1])
              break
            end
          end
          -- Open bellow task window
          kanban.fn.tasks.open(kanban, above_task)
          vim.fn.win_gotoid(above_task.win_id)
          -- kanban.fn.tasks.resize(kanban, 0)
        end
        break
      end
    end
  end
end

return M
