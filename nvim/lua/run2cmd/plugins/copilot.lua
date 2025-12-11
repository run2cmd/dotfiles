return {
  { "github/copilot.vim" },
  {
    "olimorris/codecompanion.nvim",
    config = function()
      require("codecompanion").setup({
        ignore_warnings = true
      })
    end,
  },
}
