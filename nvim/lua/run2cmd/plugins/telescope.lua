return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    config = function()
      local mapkey = vim.keymap.set
      local actions = require('telescope.actions')
      local builtin = require('telescope.builtin')
      require('telescope').setup({
        defaults = {
          file_ignore_patterns = { '.git/', '.svn/' },
          vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--hidden', },
          mappings = {
            i = {
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            previewer = false,
          },
          buffers = {
            hidden = true,
            previewer = false,
          },
          git_branches = {
            wrap_results = true,
          },
          git_bcommits = {
            wrap_results = true,
          },
          git_commits = {
            wrap_results = true,
            git_command = { 'git', 'log', '--full-history', '--format=%h%Cred%d (%cr) (%ce) %s', '--', '.' },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown({
              layout_config = {
                width = 0.5,
                height = 0.7
              }
            })
          }
        }
      })

      mapkey('n', '<C-p>', builtin.find_files)
      mapkey('n', '<C-h>', builtin.buffers)
      mapkey('n', '<C-s>',
        function()
          require('telescope.builtin').find_files({hidden=true, no_ignore=true})
        end
      )
      mapkey('n', '<leader>sl', builtin.live_grep)

    end
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },

  {
    'nvim-telescope/telescope-ui-select.nvim'
  },
}
