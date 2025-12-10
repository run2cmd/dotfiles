require("editorconfig").properties.end_of_line = function(_, val, opts)
  if not opts.end_of_line then
    return "lf"
  else
    return val
  end
end
