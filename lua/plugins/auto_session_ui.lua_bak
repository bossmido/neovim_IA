return {
  {
    "MinecraftPotatoe/AutosessionUI.nvim",
    cmd = { "AutosessionUI" },
    keys = {
      "<leader>s",
      "<leader>sp",
      "<leader>sa",
      "<leader>sr",
      "<leader>sf",
    },
    dependencies = {
      {
        "rmagatti/auto-session",
         lazy=false, -- loads lazily without blocking startup
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
      "nvim-telescope/telescope.nvim", -- for Telescope picker
      "folke/which-key.nvim", -- make sure which-key is available
    },

    opts = {
      auto_session_suppress_dirs = { "~/", "/" },
    },

    init = function()
      local ok, wk = pcall(require, "which-key")
      if not ok then
        return
      end

      wk.add({
        { "<leader>s", group = "Sessions", icon = "" },
        { "<leader>sp", desc = "Pick session",      cmd = ":AutosessionUI pick<CR>" },
        { "<leader>sa", desc = "Add/Rename session", cmd = ":AutosessionUI add<CR>" },
        { "<leader>sr", desc = "Remove session",    cmd = ":AutosessionUI remove<CR>" },
        { "<leader>sf", desc = "Toggle favorite",   cmd = ":AutosessionUI favorite<CR>" },
      })
    end,
  },
}

