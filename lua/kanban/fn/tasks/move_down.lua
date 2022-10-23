local M = {}

function M.move_down(kanban, task)
  for i in pairs(kanban.items.lists) do
    local list = kanban.items.lists[i]
    for j in pairs(list.tasks) do
      if list.tasks[j].win_id == task.win_id then
        local below_task = list.tasks[j+1]
        -- Up without scroll
        if j < #list.tasks and below_task.win_id ~= nil then
          vim.fn.win_gotoid(below_task.win_id)
        -- Up with scroll
        elseif j < #list.tasks and below_task.win_id == nil then
          -- Close head task window
          for k in pairs(list.tasks) do
            if list.tasks[k].win_id ~= nil then
              kanban.fn.tasks.close(list.tasks[k])
              break
            end
          end
          -- Open bellow task window
          kanban.fn.tasks.open(kanban, below_task)
          vim.fn.win_gotoid(below_task.win_id)
          -- kanban.fn.tasks.resize(kanban, 0)
        end
        break
      end
    end
  end

end

return M


