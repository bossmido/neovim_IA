return {
    "olimorris/codecompanion.nvim",
    cmd = "CodeCompanion",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        local adapters = require("codecompanion.adapters.http") -- use the new http module

        -- Extend the deepseek adapter
        local deepseek_adapter = adapters.extend("deepseek", {
            env = {
                api_key = vim.fn.getenv("DEEPSEEK_API_KEY"),
            },
        })

        -- Setup CodeCompanion
        require("codecompanion").setup({
            adapters = {
                deepseek = deepseek_adapter, -- pass the adapter object directly
            },
            strategies = {
                chat = { adapter = "deepseek" },
                inline = { adapter = "deepseek" },
                agent = { adapter = "deepseek" },
            },
            extensions = {
                reasoning = {
                    callback = "codecompanion._extensions.reasoning",
                    opts = { enabled = true },
                },
            },
        })
    end,
}

