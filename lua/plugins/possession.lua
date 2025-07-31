return
{
    "jedrzejboczar/possession.nvim",
    cmd = { "PossessionLoad", "PossessionSave", "PossessionDelete", "PossessionList" },
    keys = {
        { "<leader>ss", "<cmd>PossessionSave<cr>",   desc = "Save session" },
        { "<leader>sl", "<cmd>PossessionLoad<cr>",   desc = "Load session" },
        { "<leader>sd", "<cmd>PossessionDelete<cr>", desc = "Delete session" },
        { "<leader>sp", "<cmd>PossessionList<cr>",   desc = "List sessions" },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim", -- optional for picker integration
    },
    config = function()
        require("possession").setup({
            autosave = {
                current = true, -- auto-save session when exiting Neovim
                tmp = true,
            },
            commands = {
                save = "SessionSave",
                load = "SessionLoad",
                delete = "SessionDelete",
            },
        })

        -- Optional: Telescope integration
        require("telescope").load_extension("possession")
    end,
}
