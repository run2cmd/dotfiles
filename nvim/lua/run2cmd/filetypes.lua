local addtype = vim.filetype.add
local helpers = require("run2cmd.helper-functions")

helpers.create_autocmds({
  filetypes = {
    { event = { "FileType" }, opts = { pattern = "markdown", command = "setlocal spell" } },
    { event = { "FileType" }, opts = { pattern = "Terminal", command = "setlocal nowrap" } },
    { event = { "Filetype" }, opts = { pattern = "puppet", command = "setlocal iskeyword+=: commentstring=#\\ %s" } },
    { event = { "Filetype" }, opts = { pattern = "gitcommit", command = "setlocal textwidth=250" } },
  },
})

addtype({
  pattern = {
    [".*.groovy"] = function(_, bufnr)
      local content = vim.api.nvim_buf_get_lines(bufnr, 1, 3, false)
      local type = "groovy"
      for _, c in ipairs(content) do
        if string.match(c, [[.*filetype=Jenkinsfile.*]]) then
          type = "Jenkinsfile"
        end
      end
      return type
    end,
  },
})

addtype({ extension = { note = "note" } })

addtype({ extension = { tf = "hcl" } })
addtype({ extension = { tfvars = "hcl" } })
addtype({ extension = { terraformrc = "hcl" } })
addtype({ extension = { tfstate = "json" } })

local function set_yaml(bufnr)
  local content = vim.api.nvim_buf_get_lines(bufnr, 1, 10, false)
  local is_helm = false
  local is_ansible = false

  for _, line in ipairs(content) do
    if (line:match("apiVersion:") or line:match("kind:")) then
      is_helm = true
    end

    if (line:match("^%- hosts:") or line:match("^%- name:")) then
      is_ansible = true
    end

    if is_helm or is_ansible then
      break
    end
  end

  if is_helm then
    return "helm"
  end

  if is_ansible then
    return "yaml.ansible"
  end

  return "yaml"
end
addtype({
  pattern = {
    [".*.yaml"] = function(_, bufnr)
      return set_yaml(bufnr)
    end,
    [".*.yml"] = function(_, bufnr)
      return set_yaml(bufnr)
    end,
  },
})

addtype({
  pattern = {
    ["Gemfile.*"] = function(_, _)
      return "ruby"
    end,
  },
})
