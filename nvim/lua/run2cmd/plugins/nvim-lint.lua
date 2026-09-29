return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require('lint')

      lint.linters.standardrb.ignore_exitcode = true
      lint.linters['npm-groovy-lint'].args = { '-c', vim.fn.expand('~'), '-o', 'json', '-' }
      table.insert(lint.linters.tidy.args, 1, '-xml')

      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.INFO] = "I",
            [vim.diagnostic.severity.HINT] = "H",
          },
        },
        underline = true,
        virtual_text = false,
        severity_sort = true,
        float = { border = "rounded", source = true },
      })

      lint.linters.terragrunt_hclfmt = {
        cmd = 'terragrunt',
        args = { 'hcl', 'fmt', '--check', '--log-format', 'bare', '--file' },
        stdin = false,
        stream = 'stderr',
        ignore_exitcode = true,
        parser = function(output, bufnr)
          local diagnostics = {}
          local message_line

          for line in output:gmatch('[^\r\n]+') do
            if line:match('^ERRO%[') then
              message_line = line
            end
          end

          if not message_line then
            return diagnostics
          end

          if message_line:find('needs formatting') then
            return diagnostics
          end

          -- Extract line and column from error message if present
          local lnum, col = 0, 0
          local line_col = string.match(message_line, ':(%d+),(%d+)%s*%-?%d*:?')
          if line_col then
            lnum, col = string.match(message_line, ':(%d+),(%d+)')
            lnum = tonumber(lnum) and tonumber(lnum) - 1 or 0
            col = tonumber(col) and tonumber(col) - 1 or 0
          end

          -- Ensure message contains text after last ':'
          local message = ''
          local last_colon = message_line:match("^.*():")
          if last_colon then
            local after_colon = message_line:sub(last_colon + 1):match("^%s*(.-)%s*$")
            if after_colon ~= '' then
              message = after_colon
            end
          end

          if message_line ~= '' then
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

      lint.linters.puppet_lint = {
        cmd = 'puppet-lint',
        stdin = false,
        append_fname = true,
        ignore_exitcode = true,
        args = {
          '--log-format', '%{path}:%{linenumber}:%{column}: %{kind}: %{message} (%{check})',
          '--no-autoloader_layout-check',
        },
        parser = require('lint.parser').from_pattern(
          '(.-):(%d+):(%d+): (%a+): (.+)',
          { 'file', 'lnum', 'col', 'severity', 'message' },
          { error = vim.diagnostic.severity.ERROR, warning = vim.diagnostic.severity.WARN },
          { ["source"] = "puppet-lint" }
        ),
      }

      lint.linters.puppet_parser_validate = {
        cmd = 'puppet',
        stdin = false,
        append_fname = true,
        ignore_exitcode = true,
        stream = 'stderr',
        args = { 'parser', 'validate', '--color=false' },
        parser = require('lint.parser').from_errorformat(
          '%E%m (file: %f\\, line: %l\\, column: %c)',
          { source = 'puppet-parser' }
        ),
      }

      local function find_chart_root(bufnr)
        local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr or 0), ':p:h')
        while dir and dir ~= '' and dir ~= '/' do
          if vim.uv.fs_stat(dir .. '/Chart.yaml') then
            return dir
          end
          dir = vim.fn.fnamemodify(dir, ':h')
        end
        return nil
      end

      lint.linters.helm_lint = {
        cmd = 'helm',
        stdin = false,
        append_fname = false,
        ignore_exitcode = true,
        args = {
          'lint',
          function()
            return find_chart_root(0) or vim.fn.expand('%:p:h')
          end,
        },
        parser = function(output)
          local diagnostics = {}
          local chart_root = find_chart_root(0) or vim.fn.expand('%:p:h')
          local current_file = vim.fn.expand('%:p')

          local severity_map = {
            ERROR = vim.diagnostic.severity.ERROR,
            WARNING = vim.diagnostic.severity.WARN,
            INFO = vim.diagnostic.severity.INFO,
          }

          for line in output:gmatch('[^\r\n]+') do
            local level, path, lnum, message = line:match('^%[(%u+)%]%s+.-:%s+.-%((%S-):(%d+)%):%s*(.*)$')

            if not level then
              level, path, message = line:match('^%[(%u+)%]%s+([^:]+):%s+(.*)$')
            end

            if level and severity_map[level] then
              if lnum then
                path = path:gsub('^[^/]+/', '')
              end

              local abs_path = vim.fn.simplify(chart_root .. '/' .. path)

              if abs_path == current_file then
                table.insert(diagnostics, {
                  lnum = (tonumber(lnum) or 1) - 1,
                  col = 0,
                  severity = severity_map[level],
                  source = 'helm-lint',
                  message = message,
                })
              end
            end
          end

          return diagnostics
        end,
      }

      lint.linters_by_ft = {
        markdown = { "rumdl" },
        eruby = { "erb_lint" },
        groovy = { "npm-groovy-lint" },
        Jenkinsfile = { "npm-groovy-lint" },
        hcl = { 'terragrunt_hclfmt', 'tflint' },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        python = { "flake8" },
        ruby = { "standardrb" },
        yaml = { "yamllint" },
        ["yaml.ansible"] = { "yamllint", "ansible_lint" },
        json = { "jsonlint" },
        vim = { "vint" },
        lua = { "luacheck" },
        dockerfile = { "hadolint" },
        helm = { "helm_lint" },
        xml = { "tidy" },
        puppet = { "puppet_parser_validate", "puppet_lint" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end
  }
}
