return {
    'junegunn/fzf',           -- fzf binary plugin (optional but recommended)
    run = function()
      vim.fn['fzf#install']()
    end,
    lazy = true,              -- load only when needed
  }
