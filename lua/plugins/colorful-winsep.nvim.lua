return {
  "nvim-zh/colorful-winsep.nvim",
  event = { "VeryLazy", "WinNew" }, -- charge après le démarrage, ou à l’ouverture d’un split
  config = function()
    require("colorful-winsep").setup({
      -- tu peux garder tes options ici si besoin
--      highlight = {
      ---  bg = "#1e1e2e",
       --- fg = "#89b4fa",
      --},
    })
  end,
}
