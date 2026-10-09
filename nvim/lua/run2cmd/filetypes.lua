local addtype = vim.filetype.add
local helpers = require("run2cmd.helper-functions")

local function puppet_class_from_path(path)
  local abs = vim.fn.fnamemodify(path, ":p")
  local ok, tags = pcall(vim.fn.taglist, [[\c.]])
  if not ok or not tags then
    return nil
  end

  for _, t in ipairs(tags) do
    if t.kind == "c" and vim.fn.fnamemodify(t.filename, ":p") == abs then
      return t.name
    end
  end

  return nil
end

local function try_jump_to_tag(name, scope, kinds)
  local ok, tags = pcall(vim.fn.taglist, [[\c^]] .. name .. [[$]])
  if not ok or not tags or #tags == 0 then
    return false
  end

  local wanted = scope and ("::" .. scope):lower() or nil
  local match

  for _, t in ipairs(tags) do
    local kind_ok = not kinds or vim.tbl_contains(kinds, t.kind)
    local scope_ok = not wanted or (t.class and t.class:lower() == wanted)

    if kind_ok and scope_ok then
      match = t
      break
    end
  end

  if not match then
    return false
  end

  vim.cmd.edit(match.filename)

  local lnum = tonumber(match.line)
  if lnum then
    vim.api.nvim_win_set_cursor(0, { lnum, 0 })
  else
    pcall(vim.cmd, match.cmd)
  end

  return true
end

local function puppet_goto_definition(word)
  word = (word or vim.fn.expand("<cword>")):gsub("^%$", "")

  if try_jump_to_tag(word, nil, { "c", "d" }) then
    return
  end

  local class_scope, var_name = word:match("^(.*)::([^:]+)$")
  if not var_name then
    class_scope = puppet_class_from_path(vim.api.nvim_buf_get_name(0))
    var_name = word
  end

  if try_jump_to_tag(var_name, class_scope) then
    return
  end

  vim.notify("puppet: no tag found for `" .. word .. "`", vim.log.levels.WARN)
end

helpers.create_autocmds({
  filetypes = {
    { event = { "FileType" }, opts = { pattern = "markdown", command = "setlocal spell" } },
    { event = { "FileType" }, opts = { pattern = "Terminal", command = "setlocal nowrap" } },
    { event = { "Filetype" }, opts = { pattern = "puppet", command = "setlocal iskeyword+=: commentstring=#\\ %s" } },
    {
      event = { "FileType" },
      opts = {
        pattern = "puppet",
        callback = function(args)
          vim.keymap.set("n", "gd", puppet_goto_definition, { buffer = args.buf })
        end,
      },
    },
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
  local file_name = vim.api.nvim_buf_get_name(bufnr)

  if file_name:match("Chart.yaml") or file_name:match("values.yaml") then
    return "helm"
  end

  for _, line in ipairs(content) do
    if (line:match("apiVersion:") or line:match("kind:") or line:match("{{/*")) then
      return "helm"
    end

    if (line:match("^%- hosts:") or line:match("^%- name:")) then
      return "yaml.ansible"
    end
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
