return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "nvim-lua/lsp-status.nvim",
      {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
        opts = {
          check_ts = true,
        }
      },
      { "github/copilot.vim" },
      {
        "olimorris/codecompanion.nvim",
        config = function()
          require("codecompanion").setup({
            ignore_warnings = true
          })
        end,
      },
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<c-k>"] = cmp.mapping.select_prev_item(),
          ["<c-j>"] = cmp.mapping.select_next_item(),
        }),
        sources = cmp.config.sources({
          { name = "copilot", group_index = 2 },
          { name = "path" },
          { name = "nvim_lsp" },
        }, {
          { name = "buffer" },
        }),
      })

      cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
    end,
  },
}
