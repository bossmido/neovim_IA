return { --* embed LSPs inside other filetypes *--
  "jmbuhr/otter.nvim",
  event = "VeryLazy",
  dependencies = "nvim-treesitter/nvim-treesitter",
  opts = { lsp = { diagnostic_update_events = { "TextChanged" } } },
  config = function()
    require("otter").activate(languages, completion, false, tsquery) -- false: disable diagnostics
  end,
}
