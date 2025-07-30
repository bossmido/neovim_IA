--test
local luasnip = require("luasnip")

luasnip.config.set_config({
    -- Use bordered windows with rounded corners
    ext_opts = {
        [require("luasnip.util.types").choiceNode] = {
            active = {
                virt_text = { { "●", "GruvboxGreen" } }, -- or other marker
                hl_group = "Visual",
                -- set window options for floating windows:

                winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                border = "rounded",
            },
        },
    },
})
-------------------------------------------------------------------------
require("notify").setup({
    -- Make sure stages support multiline
    stages = "fade_in_slide_out",
    -- or try "slide" or "fade"
    max_width = 110,    -- adjust width if needed
    max_height = 50000, -- adjust height if needed
})




local capabilities = vim.lsp.protocol.make_client_capabilities()

-- If using nvim-cmp
local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- Fix offsetEncoding for clangd
capabilities.offsetEncoding = { "utf-8" }

require("lspconfig").clangd.setup {
    capabilities = capabilities,
} -----------------------------------------------------------------------
require('lspconfig').lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT', -- Neovim uses LuaJIT
            },
            diagnostics = {
                globals = { 'vim' }, -- Tell the server that `vim` is a global
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true), -- Make the server aware of Neovim runtime files
                checkThirdParty = false,                           -- Optional: Avoid "missing third-party" prompts
            },
            telemetry = {
                enable = false, -- Optional: Disable telemetry
            },
        }
    }
}
--------------------------------------------------------------------------
--
--
-- local module_appelé = "blick.cmp"
-- local ok, mod = pcall(require, module_appelé)
-- if ok then
--     local capabilities = require(module_appelé).default_capabilities()
--
--     require('lspconfig').clangd.setup({
--         capabilities = capabilities,
--         on_attach = function(client, bufnr)
--             -- optional debug
--         end,
--     })
-- else
--     -- module does not exist or failed to load
-- end
