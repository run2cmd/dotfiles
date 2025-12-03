return {
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'nvim-lua/lsp-status.nvim'
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<c-k>'] = cmp.mapping.select_prev_item(),
          ['<c-j>'] = cmp.mapping.select_next_item(),
          ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = 'path' },
          { name = 'nvim_lsp' },
        },
      })

      cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
    end
  },
  { 'L3MON4D3/LuaSnip' },
  { 'saadparwaiz1/cmp_luasnip' },
}
