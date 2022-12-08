set rtp^=./vendor/plenary.nvim/
set rtp^=./vendor/matcher_combinators.lua/
set rtp^=./vendor/nvim-cmp/
set rtp^=../

runtime plugin/plenary.vim

lua require('plenary.busted')
lua require('telescope').setup({})
lua require('matcher_combinators.luassert')
lua require('cmp').setup({})

" configuring the plugin
runtime plugin/kanban.lua
lua require('kanban').setup({})
