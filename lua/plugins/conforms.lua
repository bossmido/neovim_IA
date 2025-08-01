return {
  'stevearc/conform.nvim',
  version="*",
      opts = {
    formatters_by_ft = {
    --    ['*'] = {
    --   function()
    --     return {
    --       exe = "prettier",
    --       args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
    --       stdin = true,
    --     }      end,

      cpp = { "clang_format" },
      c = { "clang_format" },
      lua = {
      function()
        return {
          exe = "stylua",
          args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "-" },
          stdin = true,
        }
      end
    },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier" },
      css        = { "prettierd", "prettier" },

      html        = { "prettierd", "prettier" },
  },    format_on_save = {
      timeout_ms =1000,

          lsp_format = "fallback",
    },   format = function(bufnr)
      require("conform").format({
        bufnr = bufnr,
        stop_after_first=true,
        async = true,
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
