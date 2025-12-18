return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require('lint')

      lint.linters.terragrunt_hclfmt = {
        cmd = 'terragrunt',
        args = { 'hcl', 'fmt', '--check', '--log-format', 'bare', '--file' },
        stdin = false,
        stream = 'stderr',
        ignore_exitcode = true,
        parser = function(output, bufnr)
          local diagnostics = {}

          local lines = vim.split(output, '\n')
          local second_from_bottom = lines[#lines - 2]

          -- Ignore if the message contains 'needs formatting'
          if second_from_bottom:find('needs formatting') then
            return diagnostics
          end

          -- Extract line and column from error message if present
          local lnum, col = 0, 0
          local line_col = string.match(second_from_bottom, ':(%d+),(%d+)%s*%-?%d*:?')
          if line_col then
            lnum, col = string.match(second_from_bottom, ':(%d+),(%d+)')
            lnum = tonumber(lnum) and tonumber(lnum) - 1 or 0
            col = tonumber(col) and tonumber(col) - 1 or 0
          end

          -- Ensure message contains text after last ':'
          local message = ''
          local last_colon = second_from_bottom:match("^.*():")
          if last_colon then
            local after_colon = second_from_bottom:sub(last_colon + 1):match("^%s*(.-)%s*$")
            if after_colon ~= '' then
              message = after_colon
            end
          end

          if second_from_bottom ~= '' then
            table.insert(diagnostics, {
              lnum = lnum,
              col = col,
              end_lnum = lnum,
              end_col = col,
              severity = vim.diagnostic.severity.ERR,
              source = 'terragrunt_hclfmt',
              message = message,
            })
          end

          return diagnostics
        end,
      }

      lint.linters_by_ft = {
        markdown = { "rumdl" },
        eruby = { "erb_lint" },
        groovy = { "npm-groovy-lint" },
        Jenkinsfile = { "npm-groovy-lint" },
        hcl = { 'terragrunt_hclfmt' },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end
  }
}
