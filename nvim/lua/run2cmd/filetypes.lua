local addtype = vim.filetype.add

-- Set Jenkinsfile filetype before all other code execution.
addtype({
  pattern = {
    ['.*.groovy'] = function(_, bufnr)
      local content = vim.api.nvim_buf_get_lines(bufnr, 1, 3, false)
      local type = 'groovy'
      for _, c in ipairs(content) do
        if string.match(c, [[.*filetype=Jenkinsfile.*]]) then
          type = 'Jenkinsfile'
        end
      end
      return type
    end,
  },
})

-- Add notes
addtype({ extension = { note = 'note' } })

-- Terraform support
addtype({ extension = { tf = 'hcl' } })
addtype({ extension = { tfvars = 'hcl' } })
addtype({ extension = { terraformrc = 'hcl' } })
addtype({ extension = { tfstate = 'json' } })

-- Ansible support
local function set_yaml(bufnr)
  local content = vim.api.nvim_buf_get_lines(bufnr, 1, 10, false)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local matcher = { '^- hosts:', '^- name:' }
  local type = 'yaml'
  if string.find(filename, 'templates') then
    type = 'helm'
  end
  for _, m in ipairs(matcher) do
    for _, c in ipairs(content) do
      if string.match(c, m) then
        type = 'yaml.ansible'
      end
    end
  end
  return type
end
addtype({
  pattern = {
    ['.*.yaml'] = function(_, bufnr)
      return set_yaml(bufnr)
    end,
    ['.*.yml'] = function(_, bufnr)
      return set_yaml(bufnr)
    end,
  },
})
