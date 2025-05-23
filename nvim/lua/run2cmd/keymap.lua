local mapkey = vim.keymap.set
local helpers = require('run2cmd.helper-functions')

for _, key in ipairs({ "h", "j", "k", "l", "+", "-" }) do
  local count = 0
  local timer = assert(vim.loop.new_timer())
  local map = key
  vim.keymap.set("n", key, function()
    if vim.v.count > 0 then
      count = 0
    end
    if count >= 4 then
      print("Hold on man. Use repeaters.")
    else
      count = count + 1
      timer:start(2000, 0, function()
        count = 0
      end)
      return map
    end
  end, { expr = true, silent = true })
end

mapkey('n', '<silent> <c-l>', ":nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>")

mapkey('n', '<Up>', '')
mapkey('n', '<Down>', '')
mapkey('n', '<Left>', '')
mapkey('n', '<Right>', '')

mapkey('n', '<leader>tn', ':tabnext<CR>')
mapkey('n', '<leader>tp', ':tabprevious<CR>')

mapkey('n', '<leader>c', ":call system(['tmux', 'display-popup', '-E', '-d', getcwd()])<CR>")

mapkey('c', '<C-k>', '<Up>')
mapkey('c', '<C-j>', '<Down>')

mapkey('n', '<leader>f', ":let @+=expand('%:p')<CR>")

mapkey('v', '<leader>y', "\"+y :call system('clip.exe', @+)<CR><CR>")

mapkey('n', '<leader>qo', ':copen<CR>')
mapkey('n', '<leader>qc', ':cclose<CR>')

mapkey('n', ']q', ':cnext<CR>')
mapkey('n', '[q', ':cprev<CR>')

mapkey('n', ']l', ':lnext<CR>')
mapkey('n', '[l', ':lprev<CR>')

mapkey('n', ']b', ':bnext<CR>')
mapkey('n', '[b', ':bprev<CR>')
