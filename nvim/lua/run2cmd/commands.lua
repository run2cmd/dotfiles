--
-- Custom commands
--
local cmd = vim.api.nvim_create_user_command

cmd('Config', ':e ~/dotfiles/README.md', {})

-- Run call to https://cht.sh with provided artuments
cmd('Doc',
  function(params)
    local buffer = vim.t.doc_window_buffer
    if buffer and vim.api.nvim_buf_is_valid(buffer) then
      vim.api.nvim_buf_delete(buffer, {})
    end
    vim.cmd('split term://chtsh ' .. params.args)
    vim.t.doc_window_buffer = vim.api.nvim_get_current_buf()
  end,
  { nargs = '*' }
)
