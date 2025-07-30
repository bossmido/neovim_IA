--test
local luasnip = require("luasnip")

luasnip.config.set_config({
  -- Use bordered windows with rounded corners
  ext_opts = {
    [require("luasnip.util.types").choiceNode] = {
      active = {
        virt_text = { { "●", "GruvboxGreen" } }, -- or other marker
        hl_group = "Visual",
        -- set window options for floating windows:

        winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        border = "rounded",
      },
    },
  },
})
-------------------------------------------------------------------------
