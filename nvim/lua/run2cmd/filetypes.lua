local addtype = vim.filetype.add

-- Set Jenkinsfile filetype before all other code execution.
addtype({
  pattern = {
    ['.*.groovy'] = function(_, bufnr)
      local content = vim.filetype.getlines(bufnr, 1)
      if vim.filetype.matchregex(content, [[.*filetype=Jenkinsfile.*]]) then
        return 'Jenkinsfile'
      else
        return 'groovy'
      end
    end,
  },
})

-- Add notes
addtype({ extension = { note = 'note' } })

-- Terraform support
addtype({ extension = { tf = 'hcl' }})
addtype({ extension = { tfvars = 'hcl' }})
addtype({ extension = { terraformrc = 'hcl' }})
addtype({ extension = { tfstate = 'json' }})

-- Ansible support
local function set_ansible(bufnr)
  local content = vim.filetype.getlines(bufnr, 1, 10)
  local matcher = { "^- hosts:", "^- name:" }
  local doset = false
  for _, m in ipairs(matcher) do
    for _, c in ipairs(content) do
      if string.match(c, m) then
        doset = true
      end
    end
  end
  if doset then
    return 'yaml.ansible'
  else
    return 'yaml'
  end
end
addtype({
  pattern = {
    ['.*.yaml'] = function(_, bufnr)
      return set_ansible(bufnr)
    end,
    ['.*.yml'] = function(_, bufnr)
      return set_ansible(bufnr)
    end
  },
})
