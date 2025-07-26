return {
  "Shougo/denite.nvim",
  lazy = false, -- or set an event like `"VeryLazy"` or a command
  dependencies = {
    "Shougo/neomru.vim",        -- optional: recent files
    "Shougo/neoyank.vim",       -- optional: yank history
    "Shougo/unite-outline",     -- optional: symbol outline
  },
  config = function()
    -- optional: map a key to open denite
    vim.api.nvim_set_keymap("n", "<leader>ff", ":Denite file_rec<CR>", { noremap = true, silent = true })
  end,
}