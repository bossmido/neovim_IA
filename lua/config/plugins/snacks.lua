return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
        require("snacks").setup({
            dashboard = {
                enabled = true,
                sections = {
                    { section = "header" },
                    { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1, limit = 5 },
                    { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1, limit = 5 },
                    { section = "startup" },
                },
            }
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesActionRename",
            callback = function(event)
                Snacks.rename.on_rename_file(event.data.from, event.data.to)
            end,
        })
    end
}
