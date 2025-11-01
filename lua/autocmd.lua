-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

-- Help file layout
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  callback = function()
    if vim.fn.winwidth(0) > 200 then vim.cmd("wincmd L") end
  end,
})

-- Terminal display adjustments
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- Open Neo-tree if launched with a directory
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local dir = vim.fn.argv(0)
    if dir and vim.fn.isdirectory(dir) == 1 then
      vim.cmd("Neotree dir=" .. dir)
    end
  end,
})

-- Live-server auto start (only if installed)
if vim.fn.exists(":LiveServerStart") == 2 then
  vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
    pattern = { "*.html", "*.css", "*.js" },
    callback = function() vim.cmd("LiveServerStart") end,
  })
end

-- Auto mkdir and notify on new files
local aug = vim.api.nvim_create_augroup("AutoMkdirNotify", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = aug,
  pattern = "*",
  callback = function(ev)
    local file = vim.loop.fs_realpath(ev.match) or ev.match
    local dir = vim.fn.fnamemodify(file, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
      vim.b.__auto_mkdir__ = true
    end
  end,
})
vim.api.nvim_create_autocmd("BufWritePost", {
  group = aug,
  pattern = "*",
  callback = function(ev)
    if vim.b.__auto_mkdir__ then
      vim.notify("✚ dossier(s) parent(s) créé(s) : " .. ev.match, vim.log.levels.INFO)
    end
  end,
})

-- Fix session restore
vim.api.nvim_create_autocmd("User", {
  pattern = "AutoSessionRestorePost",
  callback = function()
    vim.g.AutoSession_restored = true
    vim.cmd("doautocmd User AlphaReady")
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        vim.api.nvim_exec_autocmds("BufReadPost", { buffer = buf })
      end
    end
    pcall(require, "cmp")
  end,
})

-- Auto cd into project dir
if pcall(require, "toggleterm") then
  local path = vim.fn.expand("%:p")
  if vim.fn.isdirectory(path) == 1 then
    vim.api.nvim_create_autocmd("VimEnter", {
      command = "silent! cd %:p | TermExec open=0 cmd='cd %:p && clear'",
    })
  else
    vim.api.nvim_create_autocmd("VimEnter", {
      command = "silent! cd %:p:h | TermExec open=0 cmd='cd %:p:h && clear'",
    })
  end
end
