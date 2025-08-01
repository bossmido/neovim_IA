
 return {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",  -- important: install npm deps
    ft = { "markdown" },               -- load only for markdown files
    config = function()
      vim.cmd("let g:mkdp_auto_start = 1") -- optional: auto start preview
    end,
  }


