--
-- Auto completion
--
local cmp = require('cmp')
local luasnip = require('luasnip')
local auto_pairs = require('nvim-autopairs')
local pairs_cmp = require('nvim-autopairs.completion.cmp')
local surround = require('nvim-surround')
local comment = require('Comment')

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

-- Typing auto completion
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<c-k>'] = cmp.mapping.select_prev_item(),
    ['<c-j>'] = cmp.mapping.select_next_item(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end,
      },
    },
    { name = 'path' },
    { name = 'luasnip' },
  },
})

-- Auto pairs setup
auto_pairs.setup({
  check_ts = true,
  disable_filetype = { 'TelescopePrompt' },
})
cmp.event:on('confirm_done', pairs_cmp.on_confirm_done())
