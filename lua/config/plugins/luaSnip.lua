return {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" }, -- Optional: prebuilt snippets
    config = function()
        require("luasnip.loaders.from_vscode").lazy_load({
            paths = { "./my-snippets", "~/.config/nvim/snippets" }
        })
    end,
}
