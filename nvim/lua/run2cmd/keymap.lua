local mapkey = vim.keymap.set
local helpers = require('run2cmd.helper-functions')

local function tmux_terminal()
  if helpers.tmux_id() == '0' then
    helpers.open_tmux()
  else
    local id = helpers.tmux_id()
    helpers.tmux_cmd(id, 'cd ' .. vim.uv.cwd() .. ' && clear')
  end
end

for _, key in ipairs({ "h", "j", "k", "l", "+", "-" }) do
  local count = 0
  local timer = assert(vim.loop.new_timer())
  local map = key
  vim.keymap.set("n", key, function()
    if vim.v.count > 0 then
      count = 0
    end
    if count >= 5 then
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

mapkey('n', '<leader>c', tmux_terminal)

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
