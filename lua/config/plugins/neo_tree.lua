-- lua/plugins/neo-tree.lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v4.x",  -- or "v4.x" if you're using the latest
  dependencies = {
    "nvim-lua/plenary.nvim",        -- Required
    "nvim-tree/nvim-web-devicons",  -- Optional, for icons
    "MunifTanjim/nui.nvim",         -- UI library
    -- optional for file watching
    "s1n7ax/nvim-window-picker",    -- Optional: window selection when opening files
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle Neotree" },
    {"<C-t>", "<cmd>Neotree toggle<CR>", desc = "Toggle Neo-tree with Ctrl-P" },

  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
      },
      window = {
        position = "left",
        width = 35,
        mappings = {
          ["<space>"] = "toggle_node",
          ["<cr>"] = "open",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["q"] = "close_window",
        },
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = true,
        },
      },
    })
  end,
}
