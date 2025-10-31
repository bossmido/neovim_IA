return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "alfaix/neotest-gtest",
    "rouge8/neotest-rust",
    "nvim-neotest/neotest-python",
    "olimorris/neotest-phpunit",
  },
  keys = {
    {
      "<F8>",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run current file with neotest",
      mode = { "n", "i" },
    },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
        }),
        require("neotest-rust"),
        require("neotest-gtest"),
        require("neotest-phpunit"),
      },
    })
  end,
}

