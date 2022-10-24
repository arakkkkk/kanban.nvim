local M = {}

function M.(kanban)
  vim.api.nvim_create_autocmd("InsertLeave", {
    once = true,
    callback = function()
      kanban.fn.kwindow.close(kanban)
    end,
  })
end

return M
