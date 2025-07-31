return{
  "lervag/vimtex",
  lazy = false,     -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  ft="tex",
  init = function()
vim.g.vimtex_enabled = 1

-- Set the compiler method (default is latexmk)
vim.g.vimtex_compiler_method = 'latexmk'

-- View method, typically 'zathura', 'skim', or 'mupdf' depending on your PDF viewer
vim.g.vimtex_view_method = 'zathura'

-- Optional: open PDF on compile success
vim.g.vimtex_compiler_latexmk = {
  build_dir = '', -- build in the same directory (change if needed)
  callback = 1,
  continuous = 1,
  executable = 'latexmk',
  options = {
    '-pdf',
    '-interaction=nonstopmode',
    '-synctex=1',
    '-shell-escape',
  },
}

-- Optional key mapping example for quick compile
vim.api.nvim_set_keymap('n', '<leader>ll', ':VimtexCompile<CR>', { noremap = true, silent = true })

-- Optional key mapping to view PDF
vim.api.nvim_set_keymap('n', '<leader>lv', ':VimtexView<CR>', { noremap = true, silent = true })


  end
}
