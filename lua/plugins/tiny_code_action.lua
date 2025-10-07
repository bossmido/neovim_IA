return {
  "rachartier/tiny-code-action.nvim",

  -- 🚀 Load only when an LSP client attaches
  event = "LspAttach",

  -- 🧩 Minimal core dependency
  dependencies = {
    "nvim-lua/plenary.nvim",

    -- Optional pickers (load *only when used*)
    { "nvim-telescope/telescope.nvim", optional = true, lazy = true },
    { "ibhagwan/fzf-lua", optional = true, lazy = true },
    { "folke/snacks.nvim", optional = true, lazy = true },
  },

  -- 🪄 Built-in lazy.nvim opts handler calls setup() automatically
  opts = {
    -- Pick one if you always use it (keeps others unloaded)
    -- picker = "telescope", -- or "fzf" | "snacks"
    icons = {
      code_action = "💡", -- example customization
    },
    ui = {
      border = "rounded",
    },
  },

  -- 🧠 No eager require, safe & fast
  config = function(_, opts)
    local ok, tiny = pcall(require, "tiny-code-action")
    if not ok then return end
    tiny.setup(opts)
vim.api.nvim_create_user_command(
  "CodeAction",
  function()
    
      require("tiny-code-action").code_action()
  end,
  { desc = "CodeAction" }
)
    -- Lazy keymap (only active after plugin loads)
    vim.keymap.set("n", "<leader>ca", function()
      require("tiny-code-action").code_action()
    end, { desc = "LSP: Code Action" })
  end,
}
