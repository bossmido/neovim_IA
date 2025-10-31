

return {
    "L3MON4D3/LuaSnip",
    version="*",
    event="LspAttach",
    dependencies = { "rafamadriz/friendly-snippets" }, -- Optional: prebuilt snippets
    config = function()
        require("luasnip.loaders.from_vscode").lazy_load({
            paths = { "~/.local/share/nvim/lazy/friendly-snippets/snippets/", "./my-snippets", "~/.config/nvim/snippets" }
        })
    end,
    build = "make install_jsregexp", -- optional but recommended for some regex-based snippets
}
