return {
    "mason-org/mason-lspconfig.nvim",
    event = "BufReadPost",
    dependencies = {
        "mason-org/mason.nvim",
        {
            "neovim/nvim-lspconfig",
            setup = {
                -- Patch all servers
                ["*"] = function(_, opts)
                    opts.capabilities = opts.capabilities or {}
                    opts.capabilities.offsetEncoding = { "utf-8" }
                end,
            },
        },
    },
    opts = {
        ensure_installed = {
            "rust_analyzer",            -- Rust
            "clangd",                   -- C, C++
            "typescript-language-server", -- JavaScript, TypeScript
            "html",                     -- HTML
            "cssls",                    -- CSS
        },
        automatic_installation = true,
        servers = {

            clangd = {
                capabilities = {

                    offsetEncoding = { "utf-8" },
                },
            },

        },
    },
}
