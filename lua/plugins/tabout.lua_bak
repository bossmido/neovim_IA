return
{
  "abecodes/tabout.nvim",
  event = "InsertCharPre", -- Lazy load just before typing
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- Required
    "hrsh7th/nvim-cmp",                -- Optional: for integration
  },
  config = function()
    require("tabout").setup({
      tabkey = "<Tab>",             -- Key to trigger tabout
      backwards_tabkey = "<S-Tab>", -- Key to go back
      act_as_tab = true,            -- Use <Tab> if no match
      act_as_shift_tab = false,
      default_tab = "<C-t>",        -- Only at line start
      default_shift_tab = "<C-d>",
      enable_backwards = true,
      completion = false,           -- Let nvim-cmp handle this
      tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
      },
      ignore_beginning = true,
      exclude = { "markdown", "help", "text" }, -- Optional performance tip
    })

    -- 🧠 If you're using nvim-cmp + luasnip, you can modify <Tab> logic like this:
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif require("tabout").jumpable() then
            require("tabout").jump_out()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      },
    })
  end,
}
