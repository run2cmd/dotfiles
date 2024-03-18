local helpers = require('run2cmd.helper-functions')

local autocmds = {
  autosave = {
    {
      event = { 'TextChanged', 'InsertLeave' },
      opts = {
        pattern = '*',
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          local excluded = { 'terminal', 'nofile', 'finished', 'gitcommit', 'startify' }

          if vim.api.nvim_buf_get_name(buffer) ~= '' then
            local modified = vim.api.nvim_buf_get_option(buffer, 'modified')
            local filetype = vim.api.nvim_get_option_value('filetype', { buf = buffer })
            local buftype = vim.api.nvim_get_option_value('buftype', { buf = buffer })

            if modified then
              if helpers.table_contains(excluded, filetype) or helpers.table_contains(excluded, buftype) then
                return
              else
                vim.cmd('write')
              end
            end
          end
        end
      },
    },
  },
}

helpers.create_autocmds(autocmds)
