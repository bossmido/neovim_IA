vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
        if vim.fn.winwidth(0) > 200 then
            vim.cmd("wincmd L")
        end
    end,
})

-- vim.api.nvim_create_autocmd('LspAttach', {
--     group = vim.api.nvim_create_augroup('lsp-attach-format-on-save', {}),
--     callback = function(args)
--         local client = vim.lsp.get_client_by_id(args.data.client_id)
--         if not client then return end
--
--         ---@diagnostic disable-next-line: param-type-mismatch
--         if client.supports_method('taxtDocument/farmatting', 0) then
--             -- Format the current buffer on save
--             vim.api.nvim_create_autocmd('BufWritePre', {
--                 buffer = args.buf,
--                 callback = function()
--                     vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
--                 end,
--             })
--         end
--     end,
-- })

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})

-- Automatically set filetype and start LSP for specific systemd unit file patterns
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.service", "*.mount", "*.device", "*.nspawn", "*.target", "*.timer" },
    callback = function()
        vim.bo.filetype = "systemd"
        vim.lsp.start({

            name = 'systemd_ls',
            cmd = { '~/.cargo/bin/systemd-lsp' }, -- Update this path to your systemd-lsp binary

            root_dir = vim.fn.getcwd(),
        })
    end,
})
---------------------------------------------------------------------------------
----- Open Neo-tree if nvim is launched with a directory
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local dir = vim.fn.argv(0)
        if dir and vim.fn.isdirectory(dir) == 1 then
            vim.cmd("Neotree dir=" .. dir)
        end
    end
})
----------------------------------------------------------------------------------
if vim.fn.executable("live-server") == 1 then
vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
  pattern = {"*.html", "*.css","script.js"},
  callback = function()
    -- Run live-server in background
    -- The trailing '&' lets it run asynchronously
--    vim.fn.system("live-server --quiet &")
      vim.cmd("LiveServerStart")
  end,
})
vim.api.nvim_create_autocmd({"BufLeave", "TextChanged"}, {
  pattern = "*.html",
  callback = function()
    if vim.bo.modified then
      vim.cmd("w")
    end
  end,
})
end
-----------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.log",
  callback = function()

    vim.cmd("q!")  -- quit current buffer first (optional)
    vim.cmd("silent !lnav " .. vim.fn.expand("%"))
  end,
})
-----------------------------------------------------------------------------------
-- Création automatique des dossiers manquants avant l’enregistrement
-- et notification lorsqu’un dossier ou un fichier est créé.
local aug = vim.api.nvim_create_augroup('AutoMkdirNotify', { clear = true })

vim.api.nvim_create_autocmd('BufWritePre', {
  group = aug,
  pattern = '*',
  callback = function(ev)
    local file = vim.loop.fs_realpath(ev.match) or ev.match
    local dir  = vim.fn.fnamemodify(file, ':p:h')

    -- Vérifie si le fichier existait avant
    local stat = vim.loop.fs_stat(file)
    vim.b.__auto_new_file__ = (stat == nil)

    -- Crée les dossiers manquants
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
      vim.b.__auto_mkdir__ = true
    else
      vim.b.__auto_mkdir__ = false
    end
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  group = aug,
  pattern = '*',
  callback = function(ev)
    local messages = {}
    if vim.b.__auto_mkdir__ then
      table.insert(messages, 'dossier(s) parent(s) créé(s)')
    end
    if vim.b.__auto_new_file__ then
      table.insert(messages, 'nouveau fichier créé')
    end
    if #messages > 0 then
      local file = vim.loop.fs_realpath(ev.match) or ev.match
      vim.notify(
        ('✚ %s : %s'):format(
          vim.fn.fnamemodify(file, ':.'),
          table.concat(messages, ' et ')
        ),
        vim.log.levels.INFO,
        { title = 'Écriture' }
      )
    end
  end,
})


---------------------------------------------------------------------
-- 🧩  Fix post-session restore missing UI / plugin state
-----------------------------------------------------------------------
vim.api.nvim_create_autocmd("User", {
  pattern = "AutoSessionRestorePost",
  callback = function()
    -- Mark that we've restored a session
    vim.g.AutoSession_restored = true

    -- 🔹 Reload Alpha highlights (in case you open dashboard later)
    vim.cmd("doautocmd User AlphaReady")

    -- 🔹 Trigger BufReadPost for all open buffers
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        vim.api.nvim_exec_autocmds("BufReadPost", {
          buffer = buf,
        })
      end
    end

    -- 🔹 Restart LSP clients if needed (in case they didn't attach)
    -- if package.loaded["lspconfig"] then
    --   for _, client in pairs(vim.lsp.get_clients()) do
    --     if not client.initialized then
    --       vim.lsp.start_client(client.config)
    --     end
    --   end
    --
    -- end

    -- 🔹 Force reload completion plugin (if lazy-loaded)
    pcall(require, "cmp")

  end,
})


vim.api.nvim_create_user_command("Z", function()
  vim.cmd("qa")
end, { desc = "Quit all and save" })


-- Enter the current directory when vim starts
-- % curr file, :p full path, :h get dir
local file_path = vim.fn.expand("%p")
local is_dir = vim.fn.isdirectory(file_path)
if is_dir == 1 then
  vim.api.nvim_create_autocmd("VimEnter", {pattern = "*", command = "silent! cd %:p"})
  vim.api.nvim_create_autocmd("VimEnter", {pattern = "*", command = "TermExec open=0 cmd='cd %:p && clear'"})
else
  vim.api.nvim_create_autocmd("VimEnter", {pattern = "*", command = "silent! cd %:p:h"})
  vim.api.nvim_create_autocmd("VimEnter", {pattern = "*", command = "TermExec open=0 cmd='cd %:p:h && clear'"})
end

