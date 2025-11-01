local M = {}

local function parse_functions(lines)
  local funcs = {}
  for _, line in ipairs(lines) do
    local clean = line:gsub("//.*", ""):gsub("^%s+", ""):gsub("%s+$", "")
    local ret, name, params =
      clean:match("^(%w[%w%s%*&:<>,]*)%s+([%w_:]+)%s*%(([^)]*)%)%s*%{")
    if ret and name and params then
      table.insert(funcs, string.format("%s %s(%s);", ret, name, params))
    end
  end
  return funcs
end

local function write_header(path, funcs)
  if #funcs == 0 then
    print("❌ No functions found.")
    return
  end

  if vim.fn.filereadable(path) == 1 then
    print("⚠️ Header already exists, skipping: " .. path)
    return
  end

  local guard = string.upper(vim.fn.fnamemodify(path, ":t:r")) .. "_H"
  local lines = {
    "#ifndef " .. guard,
    "#define " .. guard,
    "",
  }
  vim.list_extend(lines, funcs)
  table.insert(lines, "")
  table.insert(lines, "#endif /* " .. guard .. " */")
  vim.fn.writefile(lines, path)
  print("✅ Header generated → " .. path)
end

function M.generate_header()
  local buf = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buf)
  local ext = vim.fn.fnamemodify(name, ":e")

  if not (ext == "c" or ext == "cpp" or ext == "cc" or ext == "cxx") then
    print("⚠️ Not a C/C++ file")
    return
  end

  local header = vim.fn.fnamemodify(name, ":r") .. ".h"
  if vim.fn.filereadable(header) == 1 then
    print("ℹ️ Header already exists → " .. header)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local funcs = parse_functions(lines)
  write_header(header, funcs)
end

vim.api.nvim_create_user_command("GenHeader", M.generate_header, {})

return M
