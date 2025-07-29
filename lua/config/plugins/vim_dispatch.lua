return {
  "tpope/vim-dispatch",
  cmd = { "Dispatch", "Make", "Focus", "Start" },
  keys = {
    { "<leader>m", ":Make<CR>", desc = "Async Make" },
    { "<leader>r", ":Dispatch<Space>", desc = "Run Dispatch Command" },
  },
}
