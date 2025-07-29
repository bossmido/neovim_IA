return {
  "stevearc/aerial.nvim",
  opts = {
    backends = { "lsp", "treesitter", "markdown" },
    layout = {
      max_width = { 40, 0.3 },
      min_width = 20,
      default_direction = "right",
    },
    show_guides = true,
    filter_kind = false, -- Show all symbol kinds
    highlight_on_hover = true,
    autojump = false,
  },
  keys = {
    { "<leader>o", "<cmd>AerialToggle<CR>", desc = "Toggle Aerial (outline)" },
  },
}
