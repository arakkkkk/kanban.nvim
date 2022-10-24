local M = {}

function M.autocmd(kanban, task)
  vim.api.nvim_create_autocmd("TextChanged", {
    once = true,
    pattern = "<buffer=" .. task.buf_nr .. ">",
    callback = function()
      kanban.fn.tasks.save(kanban)
    end,
  })
  vim.api.nvim_create_autocmd("InsertLeave", {
    once = true,
    pattern = "<buffer=" .. task.buf_nr .. ">",
    callback = function()
      kanban.fn.tasks.save(kanban)
    end,
  })
end

return M
