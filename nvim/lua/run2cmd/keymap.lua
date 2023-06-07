-----------------------------
-- Keybindings
-----------------------------
local mapkey = vim.keymap.set

-- Clear search and diff
mapkey('n', '<silent> <c-l>', ":nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>")

-- Do not use arrow keys for movement.
mapkey('n', '<Up>', '')
mapkey('n', '<Down>', '')
mapkey('n', '<Left>', '')
mapkey('n', '<Right>', '')

-- Tab enchantments
mapkey('n', '<leader>tn', ':tabnext<CR>')
mapkey('n', '<leader>tp', ':tabprevious<CR>')

-- Terminal helper to open on the bottom
mapkey('n', '<leader>c', ':split term://bash<CR>i<CR>')

-- Remap wildmenu navigation
mapkey('c', '<C-k>', '<Up>')
mapkey('c', '<C-j>', '<Down>')

-- Copy file path to + register
mapkey('n', '<leader>f', ":let @+=expand('%:p')<CR>")

-- WSL support for Windows clipboard
mapkey('v', '<leader>y', "\"+y :call system('clip.exe', @+)<CR><CR>")

-- Easy exit terminal mode
mapkey('t', '<C-w>t', '<C-\\><C-N>')

-- Easy quickfix window
mapkey('n', '<leader>qo', ':ccopen<CR>')
mapkey('n', '<leader>qc', ':cclose<CR>')

-- Easy r10k support based on git branch
mapkey('n', '<leader>rk', ":lua require('run2cmd.helper-functions').run_term_cmd('r10k')<cr>")

-- Easy jump through quicklist items
mapkey('n', ']q', ':cnext<CR>')
mapkey('n', '[q', ':cprev<CR>')
