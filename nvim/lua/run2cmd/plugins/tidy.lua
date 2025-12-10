return {
  {
    "mcauley-penney/tidy.nvim",
    config = function()
      require("tidy").setup({ filetype_exclude = { "txt" } })
    end,
  },
}
