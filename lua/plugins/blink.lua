

return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "giuxtaposition/blink-cmp-copilot",
    "zbirenbaum/copilot.lua",
  },
  performance = {
  debounce = 100,
  throttle = 50,
  max_entries = 50,

},
  opts = {
    keymap = {
      preset = "enter",
      ["<F5>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-Space>"] = { "show", "fallback" },
          ["<Tab>"] = { "select_next", "fallback" },

    ["<S-Tab>"] = { "select_prev", "fallback" },
    },
completion = {
            menu = {
                draw = {
                    -- We don't need label_description now because label and label_description are already
                    -- combined together in label by colorful-menu.nvim.
                    columns = { { "kind_icon" }, { "label", gap = 1 } },
                    components = {
                        label = {
                            width = { fill = true, max = 60 },
                            text = function(ctx)
                                local highlights_info = require("colorful-menu").blink_highlights(ctx)
                                if highlights_info ~= nil then
                                    -- Or you want to add more item to label
                                    return highlights_info.label
                                else
                                    return ctx.label
                                end
                            end,
                            highlight = function(ctx)
                                local highlights = {}
                                local highlights_info = require("colorful-menu").blink_highlights(ctx)
                                if highlights_info ~= nil then
                                    highlights = highlights_info.highlights
                                end
                                for _, idx in ipairs(ctx.label_matched_indices) do

                                    table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                                end
                                -- Do something else
                                return highlights
                            end,
                        },
                    },
                },
            },
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
      documentation = { auto_show = false,  -- ✅ disable automatic docs popup
      auto_show_delay_ms = 500}, -- (optional) delay if you re-enable later},
      --keyword_length = 1,
        ghost_text = { enabled = false },
            trigger = {
      -- Don’t recompute completion every keystroke
      show_on_insert = true,
      show_on_trigger_character = true,
      show_on_accept_character = false,
       minimum_word_length = 3,  -- ✅ only trigger after 3 characters
    },
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

