return {

    "jcdickinson/codeium.nvim",
    config = function()
        require("codeium").setup({})

        -- Optional: Map keys to accept Codeium suggestions
        vim.api.nvim_set_keymap("i", "<C-l>", 'v:lua.codeium.accept()', { expr = true, silent = true })
        vim.api.nvim_set_keymap("i", "<C-]>", 'v:lua.codeium.dismiss()', { expr = true, silent = true })
        vim.api.nvim_set_keymap("i", "<C-;>", 'v:lua.codeium.complete()', { expr = true, silent = true })
    end,
    cmd = "Codeium",
}
