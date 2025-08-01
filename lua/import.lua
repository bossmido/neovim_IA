
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "failed to clone lazy.nvim:\n", "errormsg" },
            { out,                            "warningmsg" },
            { "\npress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
--    spec = "plugins",
    
     spec = {
     { import = "plugins" },
     },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    -- install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = false },
    extras = {
    "coding.nvim-cmp",
  },

})
--vim.schedule(function()
--  require("post_lazy")
--end)

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,  -- pour s’exécuter une seule fois
  callback = function()
    require("post_lazy")  -- ton script post-chargement
  end,
})
--vim.api.nvim_create_autocmd("CmdlineLeave", {
--  callback = function()
    ---require("post_lazy")
--end,
--})
