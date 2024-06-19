local mapkey = vim.keymap.set

local function visual_marks()
  local bufnr = vim.api.nvim_get_current_buf()
  local start_mark = vim.api.nvim_buf_get_mark(bufnr, '<')[1]
  local end_mark = vim.api.nvim_buf_get_mark(bufnr, '>')[1]
  local content = vim.api.nvim_buf_get_lines(bufnr, start_mark - 1, end_mark, false)
  return { bufnr = bufnr, startm = start_mark, endm = end_mark, content = content }
end

local function match_split(match_string, match_reg)
  local line = { nil }
  for w in string.gmatch(match_string, match_reg) do
    line[1] = w
  end
  return line[1]
end

local function register_visual()
  local keys = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
  vim.api.nvim_feedkeys(keys, 'x', false)
end

local function puppet_convert_to_spec()
  register_visual()
  local vm = visual_marks()
  local new_content = {}

  for i,t in ipairs(vm['content']) do
    t = t:gsub('([a-z:].*)[ ].*{[ ].*([\'"].*[\'"]):', 'it do##is_expected.to contain_%1(%2).with(')
    t = t:gsub("([%a%w%c]+)%s+=>", '%1:')
    t = t:gsub('::', '__')
    if i == #vm['content'] then
      t = t:gsub(' }', ')##end')
    end
    if new_content[i] then
      i = i + 1
    end
    local split_line = match_split(t, '[%a%s%c%w%p]*##')
    if split_line then
      new_content[i] = split_line:gsub('##', '')
      i = i + 1
    end
    split_line = match_split(t, '##[%a%s%c%w%p]*')
    if split_line then
      new_content[i] = split_line:gsub('##', '')
    end
    if not split_line then
      new_content[i] = t
    end
  end
  vim.api.nvim_buf_set_lines(vm['bufnr'], vm['startm'] - 1, vm['endm'], false, new_content)
end

mapkey('v', '<leader>cp',
  function(_)
    puppet_convert_to_spec()
  end
)
