return {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event="VimEnter",
  config = function ()
    vim.api.nvim_create_autocmd({ "User", "ColorScheme" }, {
  pattern = { "AlphaReady", "*" },
  callback = function()
    -- Pull colors from your current scheme for a smooth gradient
    local palette = {
      vim.api.nvim_get_hl(0, { name = "Constant" }).fg or "#f7768e",

      vim.api.nvim_get_hl(0, { name = "String" }).fg or "#9ece6a",
      vim.api.nvim_get_hl(0, { name = "Function" }).fg or "#7aa2f7",
      vim.api.nvim_get_hl(0, { name = "Type" }).fg or "#bb9af7",
      vim.api.nvim_get_hl(0, { name = "Number" }).fg or "#ff9e64",
      vim.api.nvim_get_hl(0, { name = "Keyword" }).fg or "#7dcfff",
      vim.api.nvim_get_hl(0, { name = "Identifier" }).fg or "#f7768e",
    }

    for i, c in ipairs(palette) do
      vim.api.nvim_set_hl(0, "StartLogo" .. i, { fg = c, bold = true })
      vim.api.nvim_set_hl(0, "StartLogoPop" .. i, { fg = c, bold = true, italic = true })
    end
  end,
})

      local alpha = require('alpha')

    local dashboard = require('alpha.themes.dashboard')
    local theme = require('alpha.themes.theta')

    ----------------------------------------------------------------------
    -- Define highlight groups (after colorscheme load)
    ----------------------------------------------------------------------
    local function set_header_highlights()
      -- You can change these colors to match your theme
      local colors = {
        "#ff6c6b", "#ecbe7b", "#98be65", "#51afef",
        "#c678dd", "#46d9ff", "#a9a1e1", "#f7768e",
      }

      for i, c in ipairs(colors) do
        vim.api.nvim_set_hl(0, "StartLogo" .. i, { fg = c, bold = true })
        vim.api.nvim_set_hl(0, "StartLogoPop" .. i, { fg = c, bold = true, italic = true })
      end
    end

    ----------------------------------------------------------------------
    -- Reapply highlights after colorscheme changes or Alpha load
    ----------------------------------------------------------------------
    vim.api.nvim_create_autocmd({ "ColorScheme", "User" }, {
      pattern = { "*", "AlphaReady" },
      callback = set_header_highlights,
    })

    ----------------------------------------------------------------------
    -- Define your header color logic
    ----------------------------------------------------------------------
    local function lineColor(lines, popStart, popEnd)
      local out = {}
      for i, line in ipairs(lines) do
        local hi
        if i > popStart and i <= popEnd then
          hi = "StartLogoPop" .. (i - popStart)
        elseif i > popStart then
          hi = "StartLogo" .. (i - popStart)
        else
          hi = "StartLogo" .. i
        end
        table.insert(out, { hi = hi, line = line })
      end
      return out
    end

    ----------------------------------------------------------------------
    -- Headers
    ----------------------------------------------------------------------
    local coolLines = {
      [[    ███╗   ███╗ █████╗ ██╗  ██╗███████╗   ]],
      [[    ████╗ ████║██╔══██╗██║ ██╔╝██╔════╝   ]],
      [[    ██╔████╔██║███████║█████╔╝ █████╗     ]],
      [[    ██║╚██╔╝██║██╔══██║██╔═██╗ ██╔══╝     ]],
      [[    ██║ ╚═╝ ██║██║  ██║██║  ██╗███████╗   ]],
      [[    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝   ]],
    }

    local headers = {
      lineColor(coolLines, 3, 5),
    }

    local function header_chars()
      math.randomseed(os.time())
      return headers[math.random(#headers)]
    end

    local function header_color()
      local lines = {}
      for _, lineConfig in pairs(header_chars()) do
        table.insert(lines, {
          type = "text",
          val = lineConfig.line,
          opts = {
            hl = lineConfig.hi,
            position = "center",
          },
        })
      end
      return { type = "group", val = lines, opts = { position = "center" } }
    end

    ----------------------------------------------------------------------
    -- Dashboard buttons
    ----------------------------------------------------------------------
    local buttons = {
      type = "group",
      val = {
        { type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
        { type = "padding", val = 1 },
        dashboard.button("e", "  New file", "<cmd>ene<CR>"),
        dashboard.button("f", "  Find file","<cmd>Telescope find_files<CR>"),
        dashboard.button("F", "  Find text","<cmd>Telescope<CR>"),
        dashboard.button("p", "  PROJETS","<cmd>Telescope projects<CR>"),
        dashboard.button("u", "󱐥  Update Plugins", "<cmd>Lazy sync<CR>"),
        dashboard.button("q", "󰩈  Quit", "<cmd>qa<CR>"),
      },
      position = "center",
    }

    ----------------------------------------------------------------------
    -- Final layout + setup
    ----------------------------------------------------------------------
    local themeconfig = theme.config
    themeconfig.layout[2] = header_color()
    themeconfig.layout[6] = buttons

    -- Apply highlights *after everything loads*
    vim.schedule(set_header_highlights)

    alpha.setup(themeconfig)
  end,
}

