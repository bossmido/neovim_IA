-- Display a bulb when code actions are available
require("nvim-lightbulb").setup({
  autocmd = { enabled = true },
  sign = { enabled = true },
  virtual_text = { enabled = true },
})

-- Double-click to trigger code action if bulb is active
vim.keymap.set('n', '<2-LeftMouse>', function()
  local line = vim.fn.line('.')
  local diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })
  -- Check if any code action is available
  vim.lsp.buf.code_action()
end, { desc = "Trigger code action on double-click" })
