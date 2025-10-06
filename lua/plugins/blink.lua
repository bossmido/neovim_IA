return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "giuxtaposition/blink-cmp-copilot",
    "zbirenbaum/copilot.lua",
  },
  opts = {
    keymap = {
      preset = "enter",
      ["<F5>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-Space>"] = { "show", "fallback" },
    },

    appearance = {
      nerd_font_variant = "mono",
      -- You can define kind_icons including Copilot below
      kind_icons = {
        Copilot = "",
        Text = '󰉿',
        Method = '󰊕',
        Function = '󰊕',
        Constructor = '󰒓',
        Field = '󰜢',
        Variable = '󰆦',
        Property = '󰖷',
        Class = '󱡠',
        Interface = '󱡠',
        Struct = '󱡠',
        Module = '󰅩',
        Unit = '󰪚',
        Value = '󰦨',
        Enum = '󰦨',
        EnumMember = '󰦨',
        Keyword = '󰻾',
        Constant = '󰏿',
        Snippet = '󱄽',
        Color = '󰏘',
        File = '󰈔',
        Reference = '󰬲',
        Folder = '󰉋',
        Event = '󱐋',
        Operator = '󰪚',
        TypeParameter = '󰬛',
      },
    },

    completion = {
      documentation = { auto_show = true },
      keyword_length = 1,
        ghost_text = { enabled = true },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = 100,
          async = true,
          -- optional transform function
          transform_items = function(_, items)
            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
            local kind_idx = #CompletionItemKind + 1
            CompletionItemKind[kind_idx] = "Copilot"
            for _, item in ipairs(items) do
              item.kind = kind_idx
            end
            return items
          end,
        },
      },
    },

    fuzzy = {
      implementation = "prefer_rust_with_warning",
    },
  },

  config = function(_, opts)
    -- Setup Copilot.lua, but disable its suggestion panel
    require("copilot").setup({
      suggestion = { enabled = false },
      panel = { enabled = false },
    })
    -- Load snippets
    require("luasnip.loaders.from_vscode").lazy_load()
    -- Finally setup blink.cmp
    require("blink.cmp").setup(opts)
  end,
    opts_extend = { "sources.default","keymap" },
}

