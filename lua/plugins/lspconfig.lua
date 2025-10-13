return {
    -- Mason (LSP installer)
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = true,
    },

    -- Mason LSP Config + nvim-lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "brymer-meneses/grammar-guard.nvim",
        },
        config = function()
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")

            ---------------------------------------------------------------------
            -- Force-load nvim-lspconfig if auto-session (or anything else)

            -- fired before its BufReadPre/BufNewFile events.
            ---------------------------------------------------------------------

            local lazy_ok, lazy = pcall(require, "lazy")
            if lazy_ok then
                lazy.load({ plugins = { "nvim-lspconfig" } })
            end

            local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
            if not lspconfig_ok then
                vim.notify("lspconfig not loaded yet", vim.log.levels.ERROR)
                return
            end


            mason_lspconfig.setup({
                ensure_installed = {
                    "rust_analyzer",
                    "clangd",
                    "pyright",
                    "vtsls",
                    "html",
                    "cssls",
                    "texlab",
                    "luau_lsp",
                    "emmet_ls",
                    "ltex",
                },
                automatic_installation = true,
            })

            -- Capabilities
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.offsetEncoding = { "utf-8" }

            -- ─── LSP SERVERS ────────────────────────────────────────────────

            -- clangd
            lspconfig.clangd.setup({
                capabilities = capabilities,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--pch-storage=memory",
                    "--limit-results=40",
                    "--completion-style=detailed",
                    "--header-insertion=never",
                    "--ranking-model=heuristics",
                    "--all-scopes-completion=false",
                    "--clang-tidy=false",
                    "--log=error",
                    "-j=2",
                },
            })

            -- Lua (Neovim runtime)
            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    },
                },
            })

            -- LaTeX (prefer texlab, fallback to ltex)
            local texlab_cmd = vim.fn.executable("texlab") == 1 and "texlab" or nil
            local ltex_cmd = vim.fn.executable("ltex-ls") == 1 and "ltex-ls" or nil

            if texlab_cmd then
                lspconfig.texlab.setup({
                    cmd = { texlab_cmd },
                    filetypes = { "tex", "plaintex", "bib" },
                })
            elseif ltex_cmd then
                lspconfig.ltex.setup({
                    cmd = { ltex_cmd },
                    filetypes = { "tex", "markdown", "plaintext" },
                    settings = {
                        ltex = {
                            language = "fr",
                            diagnosticSeverity = "information",
                            enabled = { "fr" },
                            disabledRules = {},
                        },
                    },
                })
            else
                vim.notify("No LaTeX LSP server found. Install texlab or ltex-ls", vim.log.levels.WARN)
            end

-- VTSLS (JavaScript/TypeScript)
local ok_vtsls, vtsls = pcall(require, "vtsls")

if ok_vtsls then
    -- Register VTSLS with lspconfig (must happen before setup)
    vtsls.config({})


    local vtsls_ok, server = pcall(function() return lspconfig.vtsls end)
    if vtsls_ok and server then
        server.setup({
            cmd = { "vtsls", "--stdio" },

            filetypes = { "javascript", "typescript", "vue" },
            root_dir = lspconfig.util.root_pattern("tsconfig.json", "jsconfig.json", ".git"),

            settings = {
                typescript = { implicitProjectConfig = { checkJs = true } },
                javascript = { implicitProjectConfig = { checkJs = true } },

                vtsls = {
                    experimental = {
                        completion = { enableServerSideFuzzyMatch = true },
                    },
                },
            },
        })
    else
        vim.notify("vtsls not registered with lspconfig", vim.log.levels.WARN)
    end
else
    vim.notify("vtsls plugin not available — falling back to ts_ls", vim.log.levels.WARN)
    if lspconfig.ts_ls then
        lspconfig.ts_ls.setup({
            filetypes = { "javascript", "typescript", "vue" },
            root_dir = lspconfig.util.root_pattern("tsconfig.json", "jsconfig.json", ".git"),
            settings = {
                typescript = { implicitProjectConfig = { checkJs = true } },

                javascript = { implicitProjectConfig = { checkJs = true } },
            },

        })
    end

end


            -- Emmet
            lspconfig.emmet_ls.setup({
                filetypes = { "html", "css", "typescriptreact", "javascriptreact", "jsx", "tsx" },
                init_options = {
                    html = { options = { ["bem.enabled"] = true } },
                },
            })

            -- HTML
            lspconfig.html.setup({
                filetypes = { "html", "htmldjango", "blade" },
            })
        end,
    },
}

