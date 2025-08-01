return {
  "pocco81/auto-save.nvim",
  event = { "InsertLeave", "TextChanged" },
  opts = {
    enabled = true,
    execution_message = {
      message = function() return "" end, -- no message
      dim = 0.18,
      cleaning_interval = 1250,
    },
    debounce_delay = 135,
    condition = function(buf)
      local fn = vim.fn
      local utils = require("auto-save.utils.data")

      if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.expand("%:t"), { "COMMIT_EDITMSG" }) then
        return true
      end
      return false
    end,
    write_all_buffers = false,
  },
}
