return {
  {
    'nvim-lua/lsp-status.nvim',
    config = function()
      local lsp_status = require('lsp-status')
      lsp_status.register_progress()
      lsp_status.config({
        status_symbol = '',
        indicator_errors = 'E',
        indicator_warnings = 'W',
        indicator_info = 'I',
        indicator_hint = '?',
        indicator_ok = 'OK',
        select_symbol = false,
        show_filename = false,
      })
    end
  },
}
