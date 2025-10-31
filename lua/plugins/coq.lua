return {
    -- COQ completion plugin
    {
        "ms-jpq/coq_nvim",
        branch = "coq",
        cmd = "COQnow",
        config = function()
            -- Auto start COQ
            vim.g.coq_settings = { auto_start = true }
            --      require("coq").setup()
        end,
    },

    -- Optional COQ artifacts for LSP & snippet support
    {
        "ms-jpq/coq.artifacts",
        branch = "artifacts",
        cmd = "COQnow",
    },
}
