
return {
  -- Mason (LSP installer)
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },

  -- Mason + LSPConfig integration
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "brymer-meneses/grammar-guard.nvim",
    },
    config = function()
      ---------------------------------------------------------------------
      -- Mason setup
      ---------------------------------------------------------------------
      local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
      if not ok then
        vim.notify("mason-lspconfig not available", vim.log.levels.ERROR)
        return
      end

      mason_lspconfig.setup({
        ensure_installed = {
          "rust_analyzer",
          "clangd",
          "pyright",
          "vtsls",
          "html",
          "cssls",
          "texlab",
          "luau_lsp",
          "lua_ls",
          "emmet_ls",
          -- "ltex",
        },
        automatic_installation = true,
      })

      ---------------------------------------------------------------------
      -- Shared capabilities
      ---------------------------------------------------------------------
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.offsetEncoding = { "utf-8" }
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      ---------------------------------------------------------------------
      -- Helper function for safe setup
      ---------------------------------------------------------------------
      local lspconfig = require("lspconfig")

      local function start_server(name, opts)
        if not opts.cmd or not opts.cmd[1] then
          vim.notify("Invalid LSP command for " .. name, vim.log.levels.ERROR)
          return
        end
        if vim.fn.executable(opts.cmd[1]) == 0 then
          vim.notify("Missing LSP binary: " .. opts.cmd[1], vim.log.levels.WARN)
          return
        end
        opts.capabilities = vim.tbl_deep_extend("force", capabilities, opts.capabilities or {})
        --lspconfig[name].setup(opts)
        -- local setup = lspconfig[name] and lspconfig[name].setup
  if setup then
    setup(opts or {})
  else
    vim.notify(string.format("[LSP] Server %s exists but has no setup()", name), vim.log.levels.WARN)
  end
      end

      ---------------------------------------------------------------------
      -- clangd
      ---------------------------------------------------------------------
      start_server("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--pch-storage=memory",
          "--limit-results=40",
          "--completion-style=detailed",
          "--header-insertion=never",
          "--ranking-model=heuristics",
          "--all-scopes-completion=false",
          "--clang-tidy=false",
          "--log=error",
          "-j=2",
        },
        root_dir = require("lspconfig.util").root_pattern(".clangd", ".git"),
      })

      ---------------------------------------------------------------------
      -- lua_ls
      ---------------------------------------------------------------------
      -- start_server("lua_ls", {
      --   -- root_dir = require("lspconfig.util").root_pattern(".luarc.json", ".git"),
      --   -- settings = {
      --   --   Lua = {
      --   --     runtime = { version = "LuaJIT" },
      --   --     diagnostics = { globals = { "vim" } },
      --   --     workspace = {
      --   --       library = vim.api.nvim_get_runtime_file("", true),
      --   --       checkThirdParty = false,
      --   --     },
      --   --     telemetry = { enable = false },
      --   --   },
      --   -- },
      --c })

      ---------------------------------------------------------------------
      -- texlab / ltex
      ---------------------------------------------------------------------
      if vim.fn.executable("texlab") == 1 then
        start_server("texlab", {
          cmd = { "texlab" },
          filetypes = { "tex", "plaintex", "bib" },
        })
      elseif vim.fn.executable("ltex-ls") == 1 then
        start_server("ltex", {
          cmd = { "ltex-ls" },
          filetypes = { "tex", "markdown", "plaintext" },
          settings = {
            ltex = {
              language = "fr",
              diagnosticSeverity = "information",
            },
          },
        })
      else
        vim.notify("No LaTeX LSP found (texlab or ltex-ls)", vim.log.levels.WARN)
      end

      ---------------------------------------------------------------------
      -- vtsls / tsserver
      ---------------------------------------------------------------------
      if vim.fn.executable("vtsls") == 1 then
        start_server("vtsls", {
          cmd = { "vtsls", "--stdio" },
          filetypes = { "javascript", "typescript", "vue" },
          root_dir = require("lspconfig.util").root_pattern("tsconfig.json", "jsconfig.json", ".git"),
          settings = {
            typescript = { implicitProjectConfig = { checkJs = true } },
            javascript = { implicitProjectConfig = { checkJs = true } },
            vtsls = {
              experimental = {
                completion = { enableServerSideFuzzyMatch = true },
              },
            },
          },
        })
      elseif vim.fn.executable("tsserver") == 1 then
        vim.notify("Using tsserver fallback", vim.log.levels.INFO)
        start_server("tsserver", {
          cmd = { "tsserver" },
          filetypes = { "javascript", "typescript", "vue" },
          root_dir = require("lspconfig.util").root_pattern("tsconfig.json", "jsconfig.json", ".git"),
        })
      else
        vim.notify("No vtsls or tsserver found", vim.log.levels.WARN)
      end

      ---------------------------------------------------------------------
      -- emmet
      ---------------------------------------------------------------------
      if vim.fn.executable("emmet-ls") == 1 then
        start_server("emmet_ls", {
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
        })
      end

      ---------------------------------------------------------------------
      -- html
      ---------------------------------------------------------------------
      if vim.fn.executable("vscode-html-language-server") == 1 then
        start_server("html", {
          cmd = { "vscode-html-language-server", "--stdio" },
          filetypes = { "html", "htmldjango", "blade" },
        })
      end
    end,
  },
}



