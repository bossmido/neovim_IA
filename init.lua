vim.g.lazyvim_blink_main = true
require("config.lazy")
require("config.keymap")
require("config.autocmd")
require("config.filetype")
--ME MIENS
require("config.cpp")

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"


if vim.fn.has("win32") == 1 then
    vim.cmd("language en_US")
    vim.o.shell = "pwsh"
    vim.opt.shellslash = true
end

vim.diagnostic.config({ virtual_text = true })

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.confirm = true
vim.o.wrap = false
vim.o.cursorline = true
vim.o.cursorlineopt = "number"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.clipboard = "unnamedplus"
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes:1"
vim.opt.colorcolumn = "120"

vim.opt.formatoptions:remove({ "c", "r" })

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        vim.bo.fileformat = "unix"
    end,
})



vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        -- Set fileformat to unix to avoid ^M line endings
        vim.bo.fileformat = "unix"
        -- Remove any carriage return characters from the buffer
        vim.cmd([[%s/\r//g]])
    end,
})
-- Enable persistent undo
vim.opt.undofile = true

-- Set undo directory (change path if you prefer)
local undodir = vim.fn.expand("~/.cache/undo")
vim.opt.undodir = undodir

-- Create undo directory if it doesn't exist
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        local ext = vim.fn.expand("%:e")
        local allowed_exts = { "txt", "ini", "json", "yaml", "rs", "md", "lua", "py", "js", "ts", "sh", "c", "cpp" }

        if vim.tbl_contains(allowed_exts, ext) then
            vim.cmd("startinsert")
        end
    end
})

vim.api.nvim_create_autocmd("InsertCharPre", {
    callback = function(args)
        local char = args.char
        local col = vim.fn.col(".")
        local line = vim.api.nvim_get_current_line()
        -- Block ':q' being typed
        if char == 'q' and line:sub(col - 1, col - 1) == ':' then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<BS><Esc>", true, false, true), "n", true)
            vim.notify("Don't type ':q' into the buffer!", vim.log.levels.WARN)
        end
    end
})

-- Open fuzzy file finder with leader+f
vim.api.nvim_set_keymap('n', '<leader>f', ':Files<CR>', { noremap = true, silent = true })
-- Enable mouse support in all modes
vim.opt.mouse = 'a'

--autocompletion de ligne de commande de terminal
vim.o.wildmenu = true
vim.o.wildmode = "longest:full,full"



local noice = require("noice")

vim.keymap.set('c', '<CR>', function()
    -- Check if noice popup menu is visible and has selection
    if vim.fn.pumvisible() == 1 then
        -- Accept the highlighted completion
        return vim.api.nvim_replace_termcodes('<C-y>', true, false, true)
    else
        -- Normal Enter behavior
        return vim.api.nvim_replace_termcodes('<CR>', true, false, true)
    end
end, { expr = true })


-- Navigate between any windows (including terminals) using arrow keys
vim.keymap.set('n', '<C-Left>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-Down>', '<C-w>j', { desc = 'Move to bottom window' })
vim.keymap.set('n', '<C-Up>', '<C-w>k', { desc = 'Move to top window' })
vim.keymap.set('n', '<C-Right>', '<C-w>l', { desc = 'Move to right window' })

-- Also works in terminal mode
vim.keymap.set('t', '<C-Left>', '<C-\\><C-n><C-w>h', { desc = 'Move to left window from terminal' })
vim.keymap.set('t', '<C-Down>', '<C-\\><C-n><C-w>j', { desc = 'Move to bottom window from terminal' })
vim.keymap.set('t', '<C-Up>', '<C-\\><C-n><C-w>k', { desc = 'Move to top window from terminal' })
vim.keymap.set('t', '<C-Right>', '<C-\\><C-n><C-w>l', { desc = 'Move to right window from terminal' })

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        -- Check if there's any open terminal buffer
        local terminals_open = false
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "terminal" then
                terminals_open = true
                break
            end
        end

        -- If a terminal is open, stop auto-inserting in normal buffers
        if terminals_open and vim.bo.buftype == "" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        end
    end,
})

-- vim.defer_fn(function()
--   local ok, cmds = pcall(vim.api.nvim_get_commands, {builtin = false})
--   if not ok or not cmds then return end
--
--   for name, cmd in pairs(cmds) do
--     local lower = name:lower()
--     if lower ~= name then
--       -- Check if lowercase command already exists
--       local exists = false
--       local ok2, commands_now = pcall(vim.api.nvim_get_commands, {builtin = false})
--       if ok2 and commands_now and commands_now[lower] then
--         exists = true
--       end
--
--       if not exists then
--         local success, err = pcall(function()
--           vim.api.nvim_create_user_command(lower, function(opts)
--             local bang = opts.bang and "!" or ""
--             local args = opts.args or ""
--             vim.cmd(name .. bang .. " " .. args)
--           end, { nargs = "*", bang = true, desc = "Lowercase alias for " .. name })
--         end)
--         if not success then
--           -- Silently ignore error or print debug if you want:
--           -- print("Error creating alias for command " .. name .. ": " .. err)
--         end
--       end
--     end
--   end
-- end, 5000)
-- Disable <C-\><C-n> in terminal buffers to prevent switching to Normal mode

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        -- Disable the key to leave terminal mode
        vim.api.nvim_buf_set_keymap(0, "t", "<C-\\><C-n>", "<Nop>", { noremap = true, silent = true })
        -- Automatically start in insert mode
        vim.cmd("startinsert")
    end,
})


-- Also force insert mode every time entering terminal buffer
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if vim.bo.buftype == "terminal" then
            vim.cmd("startinsert")
        end
    end,
})



vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.omnifunc = ""
    end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {

    pattern = "*.lua_bak",
    callback = function()
        vim.bo.filetype = "lua"
    end,
})
