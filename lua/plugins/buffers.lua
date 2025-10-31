return {
  "Kaikacy/buffers.nvim",
  event = "VeryLazy", -- load after UI starts (keeps startup fast)
  version = "*",      -- always use latest stable
  keys = {
    { "<leader>bb", "<cmd>Buffers<CR>", desc = "List Buffers" },
    { "<leader>bd", "<cmd>bd<CR>", desc = "Close Current Buffer" },
  },
  config = function()
    -- Safe require (plugin may not be loaded yet)
    local ok, buffers = pcall(require, "buffers")
    if not ok then return end

    -- Basic setup (if plugin provides setup function)
    if buffers.setup then
      buffers.setup({
        -- Example options (adjust if plugin supports them)
        sort_lastused = true,
        show_numbers = true,
      })
    end
  end,
}

