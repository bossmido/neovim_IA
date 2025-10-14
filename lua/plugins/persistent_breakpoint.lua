return {
  "Weissle/persistent-breakpoints.nvim",
  event = "VeryLazy", -- load after startup
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
    local pb = require("persistent-breakpoints")
    local api = require("persistent-breakpoints.api")

    -- ⚙️ Setup

    pb.setup({
      save_dir = vim.fn.stdpath("data") .. "/dap_breakpoints",
      load_breakpoints_event = { "BufReadPost" },
    })

    -- 🪄 Make sure breakpoints are loaded on open
    vim.api.nvim_create_autocmd("BufReadPost", {
      callback = function()
        api.load_breakpoints()
      end,
    })


    -- 🧠 Keymaps (wrap API calls in functions so they always work)
    vim.keymap.set("n", "<F8>", function()
      api.toggle_breakpoint()
      vim.notify("Breakpoint toggled", vim.log.levels.INFO)
    end, { desc = "Toggle persistent breakpoint" })


    vim.keymap.set("n", "<F7>", function()
      api.clear_all_breakpoints()
      vim.notify("Breakpoints cleared", vim.log.levels.INFO)
    end, { desc = "Clear all persistent breakpoints" })

    vim.keymap.set("n", "<leader>dz", function()
      api.load_breakpoints()
      vim.notify("Breakpoints loaded", vim.log.levels.INFO)
    end, { desc = "Load all persistent breakpoints" })

  end,
}
