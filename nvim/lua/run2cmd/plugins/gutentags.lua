return {
  {
    "ludovicchabant/vim-gutentags",
    init = function()
      vim.g.gutentags_cache_dir = vim.fn.expand("~/.local/share/nvim/tags")

      vim.g.gutentags_generate_on_new = 0
      vim.g.gutentags_generate_on_missing = 0
      vim.g.gutentags_generate_on_empty_buffer = 0
      vim.g.gutentags_generate_on_write = 1

      vim.g.gutentags_modules = { "ctags" }

      local base_ctags_args = { "--tag-relative=yes", "--fields=+ailmnS" }
      vim.g.gutentags_ctags_extra_args = base_ctags_args

      local ft_lang = {
        sh = "Sh",
        python = "Python",
        ruby = "Ruby",
        yaml = "YAML",
        ["yaml.ansible"] = "YAML",
        json = "JSON",
        markdown = "Markdown",
        vim = "Vim",
        lua = "Lua",
        xml = "XML",
        hcl = "Terraform",
        groovy = "Groovy",
        Jenkinsfile = "Groovy",
        dockerfile = "Dockerfile",
        helm = "YAML",
        puppet = "PuppetManifest",
      }

      -- vim-gutentags only ever reads the *global* g:gutentags_ctags_extra_args
      -- when building the ctags command (buffer-local overrides are ignored),
      -- so swap it to the current buffer's language right before generation.
      local function set_lang_extra_args()
        local lang = ft_lang[vim.bo.filetype]
        vim.g.gutentags_ctags_extra_args = lang
          and vim.list_extend({ "--languages=" .. lang }, base_ctags_args)
          or base_ctags_args
      end

      vim.api.nvim_create_user_command("TagsInit", function()
        set_lang_extra_args()
        vim.g.gutentags_generate_on_missing = 1
        vim.cmd("GutentagsUpdate!")
        vim.g.gutentags_generate_on_missing = 0
      end, {})

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = set_lang_extra_args,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = vim.tbl_keys(ft_lang),
        callback = function(args)
          local lang = ft_lang[vim.bo[args.buf].filetype]
          vim.b[args.buf].gutentags_ctags_tagfile = lang:lower() .. ".tags"
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "puppet",
        callback = function(args)
          vim.b[args.buf].gutentags_root = "/code"
          vim.b[args.buf].gutentags_ctags_tagfile = "puppet.tags"
        end,
      })
    end,
  },
}
