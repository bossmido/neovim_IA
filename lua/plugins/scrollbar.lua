return {"petertriho/nvim-scrollbar",event="VeryLazy",
dependencies={"kevinhwang91/nvim-hlslens"}
,config=function()
    require("scrollbar").setup()
    require("scrollbar.handlers.gitsigns").setup()
    require("scrollbar.handlers.search").setup()
end}
