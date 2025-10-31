
return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    -- use the correct module name for none-ls
    local none_ls = require("null-ls")

    none_ls.setup({
      sources = {
        ---------------------------------------------------------
        -- ✅ Formatting (clang-format)
        ---------------------------------------------------------
        none_ls.builtins.formatting.clang_format.with({
          extra_args = {
            "--style=file",  -- use your .clang-format if present
          },
        }),

        ---------------------------------------------------------
        -- ✅ Diagnostics (clang-tidy / clang-check)
        ---------------------------------------------------------
      --   none_ls.builtins.diagnostics.clang_check.with({
      --     method = none_ls.methods.DIAGNOSTICS_ON_SAVE,  -- run on save
      --     extra_args = function()
      --       -- You can pass a Neovim global here
      --       local tidy_cfg = vim.g.clang_tidy_config
      --         or vim.fn.stdpath("config") .. "/clang-tidy.yaml"
      --       return {
      --         "-p=build",              -- path to compile_commands.json (optional)
      --         "--config-file=" .. tidy_cfg,
      --         "-checks=bugprone-*,performance-*,modernize-*",
      --       }
      --     end,
      --   }),
      -- },
      --
      ---------------------------------------------------------
      -- Optional keymaps and behavior
      ---------------------------------------------------------
      on_attach = function(client, bufnr)
        local map = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
        end

        map("n", "<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end)
        map("n", "<leader>cd", function()
          vim.diagnostic.open_float(nil, { focus = false })
        end)
      end,
    })
  end,
}
