local M = { "lervag/vimtex" }

M.lazy = false

M.init = function()
    vim.g.tex_flavor = "latex"
    vim.g.vimtex_indent_enabled = 0
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_view_automatic = 1
    vim.g.vimtex_quickfix_open_on_warning = 0
end

local E = { "saghen/blink.cmp" }

E.dependencies = {
{
    "micangl/cmp-vimtex",
    dependencies = {
    {
        "saghen/blink.compat",
        version = "*",
        lazy = true,
        opts = {},
    },
    },
},
}


E.opts = {
sources = {
    default = { "vimtex" },
    providers = {
    vimtex = {
        name = "vimtex",
        module = "blink.compat.source",

        score_offset = 100,
    },
    },
},
}

return { M, E }
