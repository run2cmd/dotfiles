--
-- Auto completion
--
local cmp = require('cmp')
local tabnine = require('cmp_tabnine.config')
local luasnip = require('luasnip')
local auto_pairs = require("nvim-autopairs")
local pairs_cmp = require('nvim-autopairs.completion.cmp')
local pairs_rules = require'nvim-autopairs.rule'

--vim.o.wildmode = 'list:longest,full'
vim.o.wildcharm = '<Tab>'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.cindent = true
vim.o.wildignore = '*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store'

-- Vim build-in completion
vim.o.completeopt = 'menu,menuone,noinsert,noselect'
vim.o.shortmess = vim.o.shortmess ..'cm'
vim.o.complete = string.gsub(vim.o.complete, 't', '')

-- Nice indention bar
vim.g.indentLine_char = '┊'
vim.g.indentLine_fileTypeExclude = { 'startify', 'markdown', 'alpha' }
vim.g.indentLine_bufTypeExclude = { 'finished', 'terminal', 'help', 'quickfix' }

-- Enable Omni completion if not already set
vim.o.omnifunc = 'syntaxcomplete#Complete'

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
    { name = 'buffer' },
    { name = 'cmp_tabnine' },
    { name = 'path' },
    { name = 'luasnip' },
  },
})

auto_pairs.setup({
  map_cr = true
})
cmp.event:on(
  'confirm_done',
  pairs_cmp.on_confirm_done()
)

tabnine:setup({
  max_lines = 1000,
  max_num_results = 20,
  sort = true,
  run_on_every_keystroke = true,
  snippet_placeholder = "..",
})

-- Jump to close sign in insert mode
auto_pairs.add_rules {
  pairs_rules(' ', ' ')
    :with_pair(function (opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ '()', '[]', '{}', "''", '""' }, pair)
    end),
  pairs_rules('( ', ' )')
    :with_pair(function() return false end)
    :with_move(function(opts)
        return opts.prev_char:match('.%)') ~= nil
    end)
    :use_key(')'),
  pairs_rules('{ ', ' }')
    :with_pair(function() return false end)
    :with_move(function(opts)
        return opts.prev_char:match('.%}') ~= nil
    end)
    :use_key('}'),
  pairs_rules('[ ', ' ]')
    :with_pair(function() return false end)
    :with_move(function(opts)
        return opts.prev_char:match('.%]') ~= nil
    end)
    :use_key(']'),
  pairs_rules("' ", " '")
    :with_pair(function() return false end)
    :with_move(function(opts)
        return opts.prev_char:match(".%'") ~= nil
    end)
    :use_key("'"),
  pairs_rules('" ', ' "')
    :with_pair(function() return false end)
    :with_move(function(opts)
        return opts.prev_char:match('.%"') ~= nil
    end)
    :use_key('"')
}
