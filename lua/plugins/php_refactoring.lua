return {
  'adibhanna/phprefactoring.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  ft = 'php',
  config = function()
    require('phprefactoring').setup({
      -- Configuration options
    })
  end,
}
