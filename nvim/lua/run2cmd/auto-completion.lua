--
-- Auto completion
--
local auto_pairs = require('nvim-autopairs')
local surround = require('nvim-surround')
local comment = require('Comment')
local remap = vim.api.nvim_set_keymap

--vim.o.wildmode = 'list:longest,full'
vim.o.wildcharm = '<Tab>'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.cindent = true
vim.o.wildignore = '*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store'

-- Vim build-in completion
vim.o.completeopt = 'menu,menuone,noinsert,noselect'
vim.o.shortmess = vim.o.shortmess .. 'cm'
vim.o.complete = string.gsub(vim.o.complete, 't', '')

-- Nice indention bar
vim.g.indentLine_char = '┊'
vim.g.indentLine_fileTypeExclude = { 'startify', 'markdown', 'alpha' }
vim.g.indentLine_bufTypeExclude = { 'finished', 'terminal', 'help', 'quickfix' }

-- Enable Omni completion if not already set
vim.o.omnifunc = 'syntaxcomplete#Complete'

-- Wrap text in chosen signs (brackets, quotes, etc.)
surround.setup()

-- Easy commenting
comment.setup()

-- Auto pairs setup
auto_pairs.setup({
  check_ts = true,
  disable_filetype = { 'TelescopePrompt' },
  map_cr = false,
  map_bs = false,
})

-- Typing auto completion
vim.g.coq_settings = {
  auto_start = 'shut-up',
  keymap = {
    recommended = false,
    bigger_preview = '<c-t>',
    jump_to_mark = '<c-e>',
  },
  completion = {
    smart = false,
  },
  --clients = {
  --  tabnine = {
  --    enabled = true,
  --  },
  --},
}

-- Map keys to work woth all completion methods
local function coq_mapkey(key, pum_key)
  remap('i', key, 'pumvisible() ? "' .. pum_key .. '" : "' .. key .. '"', { noremap = true, silent = true, expr = true })
end
coq_mapkey('<Esc>', '<C-e><Esc>')
coq_mapkey('<c-c>', '<C-e><c-c>')
coq_mapkey('<C-j>', '<C-n>')
coq_mapkey('<C-k>', '<C-p>')

_G.MUtils = {}

MUtils.CR = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
      return auto_pairs.esc('<c-y>')
    else
      return auto_pairs.esc('<c-e>') .. auto_pairs.autopairs_cr()
    end
  else
    return auto_pairs.autopairs_cr()
  end
end
remap('i', '<cr>', 'v:lua.MUtils.CR()', { noremap = true, silent = true, expr = true })

MUtils.BS = function()
  if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
    return auto_pairs.esc('<c-e>') .. auto_pairs.autopairs_bs()
  else
    return auto_pairs.autopairs_bs()
  end
end
remap('i', '<bs>', 'v:lua.MUtils.BS()', { noremap = true, silent = true, expr = true })
