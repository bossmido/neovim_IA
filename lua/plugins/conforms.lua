return  {
    "stevearc/conform.nvim",
    setup = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          -- JavaScript / TypeScript
          javascript = { "prettierd" },
          typescript = { "prettierd" },
          javascriptreact = { "prettierd" },
          typescriptreact = { "prettierd" },

          -- C / C++
          cpp = { "clang-format" },
          c = { "clang-format" },
        },
        format_on_save = true, -- auto format on save
      })

      -- Optional: keybinding to format manually
      vim.keymap.set("n", "<leader>f", function()
        conform.format({ async = true })
      end, { desc = "Format buffer" })
    end,
}
