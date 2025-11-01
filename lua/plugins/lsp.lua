-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  ---------------------------------------------------------------------------
  -- Mason (optional binary manager)
  ---------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },
{
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup({
        ensure_installed = {
          "clangd",          -- C / C++
          "lua_ls",          -- Lua
          "html",            -- HTML
          "cssls",           -- CSS
          "emmet_ls",        -- Emmet
          "vtsls",           -- JavaScript / TypeScript
          "eslint",          -- JS/TS linting
          "jsonls",          -- JSON
          "texlab",          -- LaTeX
        },
        automatic_installation = true,
      })
    end,
  },
  ---------------------------------------------------------------------------
  -- Pure Neovim-0.11 built-in LSP setup
  ---------------------------------------------------------------------------
  {
    -- You must give Lazy.nvim a plugin name, any existing one is fine
    "neovim/nvim-lspconfig", -- only used as container, not actually required
    event = "BufReadPre",

    config = function()
      -----------------------------------------------------------------------
      -- Shared capabilities
      -----------------------------------------------------------------------
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end
      capabilities.offsetEncoding = { "utf-8" }

      -----------------------------------------------------------------------
      -- Helper: register and autostart an LSP
      -----------------------------------------------------------------------
      local function register_lsp(name, opts)
        opts.name = name
        vim.api.nvim_create_autocmd("FileType", {
          pattern = opts.filetypes,
          callback = function(args)
            vim.lsp.start(opts, { bufnr = args.buf })
          end,
        })
      end


register_lsp("eslint", {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
  root_dir = function(fname)
    return vim.fs.dirname(vim.fs.find({ ".eslintrc", ".eslintrc.js", "package.json", ".git" }, { upward = true, path = fname })[1])
  end,
  capabilities = capabilities,
})



      register_lsp("vtsls", {
  cmd = { "vtsls", "--stdio" },
  filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" },
  root_dir = function(fname)
    return vim.fs.dirname(vim.fs.find({ "tsconfig.json", "jsconfig.json", ".git" }, { upward = true, path = fname })[1])
  end,
  settings = {
    typescript = { preferences = { includeCompletionsForImportStatements = true } },
    javascript = { preferences = { includeCompletionsForImportStatements = true } },
  },
  capabilities = capabilities,
})
      -----------------------------------------------------------------------
      -- CLANGD
      -----------------------------------------------------------------------
      register_lsp("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--pch-storage=memory",
          "--limit-results=40",
          "--completion-style=detailed",
          "--header-insertion=never",
          "--ranking-model=heuristics",
          "--clang-tidy=true",
          "--clang-tidy-checks=bugprone-*,performance-*,modernize-*",
          "--log=error",
          "-j=4", -- must be quoted!
        },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_dir = function(fname)
          local found = vim.fs.find({ ".clangd", ".git" }, { upward = true, path = fname })
          if #found > 0 then
            return vim.fs.dirname(found[1])
          else
            return vim.fn.getcwd()
          end
        end,
        capabilities = capabilities,
      })

      -----------------------------------------------------------------------
      -- HTML
      -----------------------------------------------------------------------
      register_lsp("html", {
        cmd = { "vscode-html-language-server", "--stdio" },
        filetypes = { "html", "htmldjango", "blade" },
        capabilities = capabilities,
      })

      -----------------------------------------------------------------------
      -- CSS
      -----------------------------------------------------------------------
      register_lsp("cssls", {
        cmd = { "vscode-css-language-server", "--stdio" },
        filetypes = { "css", "scss", "less" },
        capabilities = capabilities,
      })

      -----------------------------------------------------------------------
      -- EMMET
      -----------------------------------------------------------------------
      register_lsp("emmet_ls", {
        cmd = { "emmet-ls", "--stdio" },
        filetypes = {
          "html",
          "css",
          "typescriptreact",
          "javascriptreact",
          "jsx",
          "tsx",
        },
        init_options = {
          html = { options = { ["bem.enabled"] = true } },
        },
        capabilities = capabilities,
      })

      -----------------------------------------------------------------------
      -- LUA
      -----------------------------------------------------------------------
      register_lsp("lua_ls", {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              --library = vim.api.nvim_get_runtime_file("", true),
              library = {
  vim.env.VIMRUNTIME,
  vim.fn.expand("~/.config/nvim/lua"),
},
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
        capabilities = capabilities,
      })
    end,
  },
}
