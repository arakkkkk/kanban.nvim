# kanban.nvim
Neovim kanban plugin.
Manage task as a kanban boad in neovim.
Task information is import and export by markdown file.
Compatible with obsidian kanban.

## screenshots
![img_kanban](./doc/img_kanban2.png)

## Instration
Using packer
```
use  'arakkkkk/kanban.nvim'
```
Set up
Please use [template](./template.md) for first kanban project.
```
require('kanban').setup({
  kanban_md_path = {
    "/path/to/kanban/markdown/path.md",
    "/path/to/kanban/markdown/path.md",
    "/path/to/kanban/markdown/path.md",
  }
})
```
All setup options are [here](./lua/kanban/ops.lua)

## Kaymaps
All keymap are [here](./lua/kanban/keymap.lua)

| Key         | Action                                         |
|-------------|------------------------------------------------|
| <C-h/j/k/l> | Focus left/below/above/right task.             |
| <S-h/j/k/l> | Move task to left/below/above/right.           |
| gg          | Focus top task in the list.                    |
| g           | Focus borrom task in the list.                 |
| <leader>lr  | Rename list.                                   |
| <leader>la  | Add list.                                      |
| <leader>ld  | Delete list.                                   |
| <C-o>       | Add task.                                      |
| :w<CR>      | Save kanban.                                   |
| q           | Quit.                                          |
| <CR>        | Add task description in another markdown file. |

