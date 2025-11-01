return {
  "nvimtools/none-ls.nvim",
  config = function()
    local none_ls = require("null-ls")

    none_ls.setup({
      sources = {
        none_ls.builtins.diagnostics.cppcheck,
        none_ls.builtins.diagnostics.clang_check,
        none_ls.builtins.formatting.clang_format,
      },
      debug = false,
    })

    -- Optional: run clang-tidy automatically on save
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.c", "*.cpp", "*.h" },
      callback = function()
        vim.fn.jobstart({
          "clang-tidy",
          "--fix",
          "--fix-errors",
          vim.fn.expand("%:p"),
        })
      end,
    })
  end,
}
