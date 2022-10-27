local M = {}

function M.delete(kanban)
  -- local focus_win_id
  -- local remove_task_index
  local focus = kanban.fn.tasks.utils.get_focus(kanban)
  local focused_list = kanban.items.lists[focus.list_num]
  local focused_tasks = focused_list.tasks
  kanban.fn.tasks.close(focused_tasks[focus.task_num])
  table.remove(focused_tasks, focus.task_num);

  -- Open new teak in blank area
  local is_opend = false
  for i = focus.task_num, #focused_tasks do
    if focused_tasks[i].win_id == nil then
      kanban.fn.tasks.open(kanban, focused_tasks[i])
      is_opend = true
      break
    end
  end
  if not is_opend then
    for i in pairs(focused_list.tasks) do
      if focused_list.tasks[i].win_id ~= nil and i == 1 then
        break
      elseif focused_list.tasks[i].win_id then
        kanban.fn.tasks.open(kanban, focused_list.tasks[i-1])
        is_opend = true
        break
      end
    end
  end
  if not is_opend then
    kanban.fn.tasks.resize(kanban, focus.list_num)
  end

  -- Create blank task if no task in list
  if #focused_list.tasks == 0 then
		kanban.fn.tasks.add(kanban, focus.list_num, nil, "top", true)
		-- kanban.fn.tasks.open(kanban, blank_task)
  end

  -- Swich focus window
  if #focused_tasks == 1 then
    -- only one task
    vim.fn.win_gotoid(focused_tasks[1].win_id)
  elseif focus.task_num -1 == #focused_tasks then
    -- in bottom
    vim.fn.win_gotoid(focused_tasks[focus.task_num-1].win_id)
  else
    -- else
    vim.fn.win_gotoid(focused_tasks[focus.task_num].win_id)
  end
end

return M



