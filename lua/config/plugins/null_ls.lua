return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          -- Rust formatting
          null_ls.builtins.formatting.rustfmt,

          -- C++ formatting
          null_ls.builtins.formatting.clang_format,

          -- Prettier for HTML, CSS, JS, TS, JSON, etc.
          null_ls.builtins.formatting.prettier.with({
            filetypes = {
              "html",
              "css",
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",

              "json",

            },
          }),

          -- ESLint diagnostics (optional)
          null_ls.builtins.diagnostics.eslint_d.with({
            condition = function(utils)
              return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json", ".eslintrc" })
            end,
          }),

        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = 0, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      })
    end,
  },
}
