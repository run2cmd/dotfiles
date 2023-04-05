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
