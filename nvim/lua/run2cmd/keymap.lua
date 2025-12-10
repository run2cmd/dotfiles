local mapkey = vim.keymap.set

mapkey("n", "<silent> <c-l>", ":nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>")

mapkey("n", "<C-d>", "<C-d>zz")
mapkey("n", "<C-u>", "<C-u>zz")

mapkey("n", "n", "nzzzv")
mapkey("n", "N", "Nzzzv")

mapkey("n", "=ap", "ma=ap'a")

mapkey("n", "J", "mzJ`z")

mapkey("v", "J", ":m '>+1<CR>gv=gv")
mapkey("v", "K", ":m '<-2<CR>gv=gv")

mapkey("n", "<Up>", "")
mapkey("n", "<Down>", "")
mapkey("n", "<Left>", "")
mapkey("n", "<Right>", "")

mapkey("n", "<leader>tn", ":tabnext<CR>")
mapkey("n", "<leader>tp", ":tabprevious<CR>")

mapkey("c", "<C-k>", "<Up>")
mapkey("c", "<C-j>", "<Down>")

mapkey("n", "<leader>f", ":let @+=expand('%:p')<CR>")

mapkey("v", "<leader>y", "\"+y :call system('clip.exe', @+)<CR><CR>")

mapkey("n", "<leader>qo", ":copen<CR>")
mapkey("n", "<leader>qc", ":cclose<CR>")

mapkey("n", "]q", ":cnext<CR>zz")
mapkey("n", "[q", ":cprev<CR>zz")

mapkey("n", "]l", ":lnext<CR>zz")
mapkey("n", "[l", ":lprev<CR>zz")

mapkey("n", "]b", ":bnext<CR>zz")
mapkey("n", "[b", ":bprev<CR>zz")

mapkey("n", "<leader>e", vim.cmd.Ex)
