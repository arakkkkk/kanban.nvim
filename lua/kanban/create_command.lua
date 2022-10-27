local M = {}
function M.create_command(kanban, buf)
	-- Task
	vim.api.nvim_create_user_command("KanbanTaskDelete", function()
		if not kanban.active then
			return
		end
		kanban.fn.tasks.delete(kanban)
	end, {})

	-- Swich mode
	vim.api.nvim_create_user_command("KanbanSave", function()
		if not kanban.active then
			return
		end
		kanban.fn.tasks.save(kanban)
		kanban.markdown.writer.write(kanban, kanban.kanban_md_path)
	end, {})

	-- Task movement
	vim.api.nvim_create_user_command("KanbanTakeRight", function()
		if not kanban.active then
			return
		end
		kanban.fn.tasks.take.right(kanban)
	end, {})
	vim.api.nvim_create_user_command("KanbanTakeLeft", function()
		if not kanban.active then
			return
		end
		kanban.fn.tasks.take.left(kanban)
	end, {})
	vim.api.nvim_create_user_command("KanbanTakeUp", function()
		if not kanban.active then
			return
		end
		kanban.fn.tasks.take.up(kanban)
	end, {})
	vim.api.nvim_create_user_command("KanbanTakeDown", function()
		if not kanban.active then
			return
		end
		kanban.fn.tasks.take.down(kanban)
	end, {})

	-- Navigatiion task
	vim.api.nvim_create_user_command("KanbanMoveDown", function()
		if not kanban.active then
			return
		end
		kanban.fn.tasks.move.down(kanban)
	end, {})
	vim.api.nvim_create_user_command("KanbanMoveUp", function()
		if not kanban.active then
			return
		end
		kanban.fn.tasks.move.up(kanban)
	end, {})
	vim.api.nvim_create_user_command("KanbanMoveRight", function()
		if not kanban.active then
			return
		end
		kanban.fn.tasks.move.right(kanban)
	end, {})
	vim.api.nvim_create_user_command("KanbanMoveLeft", function()
		if not kanban.active then
			return
		end
		kanban.fn.tasks.move.left(kanban)
	end, {})
	vim.api.nvim_create_user_command("KanbanMoveTop", function()
		if not kanban.active then
			return
		end
		kanban.fn.tasks.move.top(kanban)
	end, {})
	vim.api.nvim_create_user_command("KanbanMoveBottom", function()
		if not kanban.active then
			return
		end
		kanban.fn.tasks.move.bottom(kanban)
	end, {})

	-- create task
	vim.api.nvim_create_user_command("KanbanTaskAddBottom", function()
		if not kanban.active then
			return
		end
		kanban.fn.tasks.add(kanban, nil, nil, "bottom", true)
	end, {})
	vim.api.nvim_create_user_command("KanbanTaskAddTop", function()
		if not kanban.active then
			return
		end
		kanban.fn.tasks.add(kanban, nil, nil, "top", true)
	end, {})

	-- close window
	vim.api.nvim_create_user_command("KanbanClose", function()
		if not kanban.active then
			return
		end
		if not kanban.active then
			return
		end
		kanban.fn.kwindow.close(kanban)
		kanban.fn.lists.close_all(kanban)
		kanban.fn.tasks.close_all(kanban)
		kanban.fn.tasks.close_all(kanban)
	end, {})

	-- List function
	vim.api.nvim_create_user_command("KanbanListDelete", function()
		kanban.fn.lists.delete(kanban)
	end, {})
	vim.api.nvim_create_user_command("KanbanListRename", function()
		kanban.fn.lists.rename(kanban)
	end, {})
	vim.api.nvim_create_user_command("KanbanListAdd", function()
		kanban.fn.lists.add(kanban, "List", true)
	end, {})

	-- Description note
	vim.api.nvim_create_user_command("KanbanTaskDescription", function()
		kanban.fn.lists.add(kanban)
	end, {})
end
return M
