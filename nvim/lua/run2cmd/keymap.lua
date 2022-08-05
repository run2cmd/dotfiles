-----------------------------
-- Keybindings
-----------------------------
local mapkey = vim.api.nvim_set_keymap

-- Clear search and diff
mapkey('n', '<silent> <c-l>', ":nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>", {})

-- Do not use arrow keys for movement. Remap to resize commands
mapkey('n', '<Up>', ':resize +2<CR>', {})
mapkey('n', '<Down>', ':resize -2<CR>', {})
mapkey('n', '<Left>', ':vert resize +2<CR>', {})
mapkey('n', '<Right>', ':vert resize -2<CR>', {})

-- Tab enchantments
mapkey('n', '<leader>w', ':tabnext<CR>', {})
mapkey('n', '<leader>b', ':tabprevious<CR>', {})

-- Terminal helper to open on the bottom
mapkey('n', '<leader>c', ':split term://bash<CR>i<CR>', {})

-- Remap wildmenu navigation
mapkey('c', '<C-k>', '<Up>', {})
mapkey('c', '<C-j>', '<Down>', {})

-- Copy file path to + register
mapkey('n', '<leader>f', ":let @+=expand('%:p')<CR>", {})

-- Terminal support
mapkey('t', '<C-W><leader>w', '<C-W>:tabnext<CR>', {})
mapkey('t', '<C-W><leader>b', '<C-W>:tabprevious<CR>', {})

-- Search word under cursor
mapkey('n', '<leader>s', 'viwy :Ggrep <C-R>"<CR>', {})
mapkey('v', '<leader>s', 'y :Ggrep <C-R>"<CR>', {})

-- WSL support for Windows clipboard
mapkey('v', '<leader>y', '"zy :call system(\'clip.exe\', @z)<CR><CR>', {})

-- Easy close terminal
mapkey('t', '<C-W>e', '<C-\\><C-N>', {})
