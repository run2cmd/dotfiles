local mapkey = vim.keymap.set

mapkey('n', '<silent> <c-l>', ":nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>")

mapkey('n', '<Up>', '')
mapkey('n', '<Down>', '')
mapkey('n', '<Left>', '')
mapkey('n', '<Right>', '')

mapkey('n', '<leader>tn', ':tabnext<CR>')
mapkey('n', '<leader>tp', ':tabprevious<CR>')

mapkey('n', '<leader>c', '<cmd>silent !tmux split && tmux resize-pane -D 10<CR>')

mapkey('c', '<C-k>', '<Up>')
mapkey('c', '<C-j>', '<Down>')

mapkey('n', '<leader>f', ":let @+=expand('%:p')<CR>")

mapkey('v', '<leader>y', "\"+y :call system('clip.exe', @+)<CR><CR>")

mapkey('t', '<C-w>t', '<C-\\><C-N>')

mapkey('n', '<leader>qo', ':ccopen<CR>')
mapkey('n', '<leader>qc', ':cclose<CR>')

mapkey('n', ']q', ':cnext<CR>')
mapkey('n', '[q', ':cprev<CR>')

mapkey('n', ']l', ':lnext<CR>')
mapkey('n', '[l', ':lprev<CR>')

mapkey('n', '<C-u>', '<C-u>zz')
mapkey('n', '<C-d>', '<C-d>zz')
