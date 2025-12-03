return {
  {
    'nvimdev/indentmini.nvim',
    config = function()
      require('indentmini').setup({
        char = '┊',
        exclude = { 'startify', 'markdown', 'alpha' },
      })
      vim.cmd.highlight("default link IndentLine Comment")
    end
  }
}
