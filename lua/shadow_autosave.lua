local api = vim.api
local fn = vim.fn

-- Highlight group for autosave text (grey)
api.nvim_command("highlight AutosaveText guifg=Grey ctermfg=Grey")

local autosave_timer = nil
local autosave_interval = 5000 -- milliseconds

-- Returns autosave file path in same dir: original + ".autosave"
local function autosave_filepath()
  local filepath = api.nvim_buf_get_name(0)
  if filepath == "" then return nil end
  return filepath .. ".autosave"
end

-- Write autosave file (silent)
local function write_autosave()
  local path = autosave_filepath()
  if not path then return end
  api.nvim_command("silent write! " .. path)
end

-- Read autosave file content
local function read_autosave()
  local path = autosave_filepath()
  if not path or fn.filereadable(path) == 0 then return nil end
  return fn.readfile(path)
end

-- Compare two files by sha256 hashes (return true if differ)
local function files_differ(file1, file2)
  if not file1 or not file2 then return false end
  if fn.filereadable(file1) == 0 or fn.filereadable(file2) == 0 then return false end
  return fn.sha256(file1) ~= fn.sha256(file2)
end

-- Highlight whole buffer in grey
local function highlight_buffer(bufnr)
  local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
  api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)
  for i = 0, #lines - 1 do
    api.nvim_buf_add_highlight(bufnr, -1, "AutosaveText", i, 0, -1)
  end
end

local function clear_highlight(bufnr)
  api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)
end

-- Debounced autosave call
local function schedule_autosave()
  if autosave_timer then
    autosave_timer:stop()
    autosave_timer:close()
  end
  autosave_timer = vim.loop.new_timer()
  autosave_timer:start(autosave_interval, 0, vim.schedule_wrap(function()
    -- Only autosave if buffer is modified and has a name
    if api.nvim_buf_get_option(0, "modified") and api.nvim_buf_get_name(0) ~= "" then
      write_autosave()
      vim.notify("Autosave file written", vim.log.levels.INFO)
    end
  end))
end

-- On buffer write: remove autosave file & clear highlight
local function on_save()
  local path = autosave_filepath()
  if path and fn.filereadable(path) == 1 then
    os.remove(path)
  end
  clear_highlight(0)
end

-- On buffer read: check for autosave file and restore if differs
local function on_read()
  local bufnr = api.nvim_get_current_buf()
  local filepath = api.nvim_buf_get_name(bufnr)
  if filepath == "" then return end

  local auto_path = autosave_filepath()
  if not auto_path or fn.filereadable(auto_path) == 0 then return end

  if files_differ(filepath, auto_path) then
    local lines = read_autosave()
    if lines then
      api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
      highlight_buffer(bufnr)
      vim.notify("Restored autosave content in grey (unsaved changes)", vim.log.levels.WARN)
    end
  end
end

-- Manual command to force autosave write
api.nvim_create_user_command("AutosaveWrite", function()
  write_autosave()
  vim.notify("Autosave file manually written", vim.log.levels.INFO)
end, {})

-- Setup autocommands
api.nvim_create_autocmd({"TextChanged", "InsertLeave"}, {
  pattern = "*",
  callback = schedule_autosave,
})

api.nvim_create_autocmd({"BufWritePost"}, {
  pattern = "*",
  callback = on_save,
})

api.nvim_create_autocmd({"BufReadPost"}, {
  pattern = "*",
  callback = on_read,
})

