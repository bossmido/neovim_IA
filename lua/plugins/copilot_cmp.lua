return {
  -- Copilot → cmp integration
  event = "BufRead",
  cmd="Copilot",
  "zbirenbaum/copilot-cmp",
  dependencies = { "zbirenbaum/copilot.lua" },
  config = function()
    require("copilot_cmp").setup()
  end,
}

