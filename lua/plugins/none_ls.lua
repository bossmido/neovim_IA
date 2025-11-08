return {
  "nvimtools/none-ls.nvim",
  config = function()
    local none_ls = require("null-ls")

    none_ls.setup({
      sources = {
        none_ls.builtins.diagnostics.cppcheck,
  --      none_ls.builtins.diagnostics.clang_check,
        none_ls.builtins.formatting.clang_format,
      },
      debug = false,
    })
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.c", "*.cpp" },
  callback = function()
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    local has_none_ls = false
    for _, c in ipairs(clients) do
      if c.name == "none-ls" or c.name == "null-ls" then
        has_none_ls = true
        break
      end
    end
    if has_none_ls then
      require("plugins.c_gen_header").generate_header()
    end
  end,
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
