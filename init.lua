require("config.lazy")
require("config.keymap")
require("config.autocmd")
require("config.filetype")

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

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        local ext = vim.fn.expand("%:e")
        local allowed_exts = { "txt","ini","json","yaml","rs", "md", "lua", "py", "js", "ts", "sh", "c", "cpp" }

        if vim.tbl_contains(allowed_exts, ext) then
            vim.cmd("startinsert")
        end
    end
})
