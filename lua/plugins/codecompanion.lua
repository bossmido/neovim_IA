return {
    "olimorris/codecompanion.nvim",
    cmd = "CodeCompanion",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("codecompanion").setup({
            adapters = {
                deepseek = function()
                    return require("codecompanion.adapters").extend("deepseek", {
                        env = {
                            api_key = vim.fn.getenv("API_KEY_DEEPSEEK"),
                        },
                    })
                end,
            },

            strategies = {

                chat = { adapter = "deepseek", },
                inline = { adapter = "deepseek" },
                agent = { adapter = "deepseek" },
            },
        })
    end
}
