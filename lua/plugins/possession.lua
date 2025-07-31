return 
{
  "jedrzejboczar/possession.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim", -- optional for picker integration
  },
  config = function()
    require("possession").setup({
      autosave = {
        current = true,  -- auto-save session when exiting Neovim
        tmp = true,
      },
      commands = {
        save = "SessionSave",
        load = "SessionLoad",
        delete = "SessionDelete",
      },
    })

    -- Optional: Telescope integration
    require("telescope").load_extension("possession")
  end,
}
