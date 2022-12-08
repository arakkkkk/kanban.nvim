# kanban.nvim
Neovim kanban plugin.
Manage task as a kanban board in neovim.
Task information is import and export by markdown file.
Compatible with [obsidian kanban](https://github.com/mgmeyers/obsidian-kanban).

## screenshots
![img_kanban](./doc/img_kanban2.png)

## Instration
Using packer
```
use 'arakkkkk/kanban.nvim'
-- Optional
use 'nvim-telescope/telescope.nvim'
```

## Usage
Please use [template](./template.md) for first kanban project.

and open kanban to enter `:KanbanOpen <file_path>`

All setup options are [here](./lua/kanban/ops.lua).

### Optional telescope search
If you installed telescope.nvim, you can search kanban project files by `KanbanOpen telescope` command.

This command search markdown files by `kanban-plugin: .+` which is same options to Obsidian kanban.


## Kaymaps
All keymap are [here](./lua/kanban/keymap.lua).

| Key          | Action                                         |
|--------------|------------------------------------------------|
| <C-h/j/k/l>  | Focus left/below/above/right task.             |
| <S-h/j/k/l>  | Move task to left/below/above/right.           |
| gg           | Focus top task in the list.                    |
| g            | Focus borrom task in the list.                 |
| \<leader\>lr | Rename list.                                   |
| \<leader\>la | Add list.                                      |
| \<leader\>ld | Delete list.                                   |
| \<C-o\>      | Add task.                                      |
| :w\<CR\>     | Save kanban.                                   |
| q            | Quit.                                          |
| \<CR\>       | Add task description in another markdown file. |

## Functions
### Tag complemention
- Tag is complement by exsisting tag
### Due complemention
If it is `2022/11/01`
- date calculation
  - `@today` -> `@2022/11/01`
  - `@2d` -> `@2022/11/03`
  - `@2w` -> `@2022/11/15`
  - `@2m` -> `@2022/12/01`
- year/month omitation
  - `@/12/03` -> `@2022/12/03`
  - `@//03` -> `@2022/11/03`
- set by week
  - `@su` -> this Sunday
  - `@nmo` -> next Monday
  - `@nntu` -> next after next Tuesday
  - `@nnnwe` -> next after next after next Wednesday
  - `@nnnn...Th` -> ... Thursday
