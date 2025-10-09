return {
  "MinecraftPotatoe/AutosessionUI.nvim",
  ---@type auto-session-ui.opts
  opts = {
  },
  cmd={"AutosessionUI"},

keys={"<leader>s","<leader>sp","<leader>sa","<leader>sr","<leader>sf"}
  ,
  init = function()
    -- This is an example how your config could look like
    -- Set your keybindings here
    local wk = require("which-key")
    wk.add({
      { "<leader>s", group = "Sessions", icon = "" },
      { "<leader>sp", desc = "Pick session", callback = ":AutosessionUI pick<CR>" },
      { "<leader>sa", desc = "Add/Rename session", callback = ":AutosessionUI add<CR>" },
      { "<leader>sr", desc = "Remove session", callback = ":AutosessionUI remove<CR>" },
      { "<leader>sf", desc = "Toggle current session as favorite", callback = ":AutosessionUI favorite<CR>" },
    })
  end,

  dependencies = {
    {"rmagatti/auto-session",
event = "VeryLazy", -- Ne bloque plus le démarrage
  cmd = { "SaveSession", "RestoreSession", "DeleteSession" },
  keys = {
    { "<leader>ss", "<cmd>SaveSession<cr>", desc = "Save session" },
    { "<leader>sr", "<cmd>RestoreSession<cr>", desc = "Restore session" },
    { "<leader>sd", "<cmd>DeleteSession<cr>", desc = "Delete session" },
  },
  config = function()
    require("auto-session").setup({
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
      auto_session_use_git_branch = true,
    })
  end,
  },
    "nvim-telescope/telescope.nvim", -- for using the telescope picker

  }
}
