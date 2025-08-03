return{
  "rcarriga/nvim-notify",
  config = function()
    require("notify").setup({
      stages = "slide",         -- or "fade", "static"
      timeout = 3000,           -- how long to show notifications
      render = "default",
      top_down = false,         -- <<== This is the key line
    })

    vim.notify = require("notify")
  end
}
