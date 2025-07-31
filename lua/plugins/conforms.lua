return {
  'stevearc/conform.nvim',
      opts = {
    formatters_by_ft = {
      cpp = { "clang_format" },
      c = { "clang_format" },
  },    format_on_save = {
      timeout_ms = 500,

      lsp_fallback = true,
    },   format = function(bufnr)
      require("conform").format({
        bufnr = bufnr,
        async = false,
        lsp_fallback = {
          timeout_ms = 500,
          --- 👇 explicitly pass utf-8
          filter = function(client)
            client.offset_encoding = "utf-8"
            return true
          end,

        },
      })
    end,
}}
