return {
  "lazymaniac/codecompanion-reasoning.nvim",
  dependencies = {
    "olimorris/codecompanion.nvim",
  },
  config = function()
    require("codecompanion-reasoning").setup({
      chat_history = {
        auto_save = true,
        auto_load_last_session = true,
        auto_generate_title = true,
        sessions_dir = vim.fn.stdpath('data') .. '/codecompanion-reasoning/sessions',
        max_sessions = 100,
        enable_commands = true,
        picker = 'auto', -- 'telescope' | 'fzf-lua' | 'snacks' | 'default' | 'auto'
        continue_last_chat = true,
        title_generation_opts = {
          adapter = nil,   -- override to force a specific adapter for title generation
          model = nil,     -- override to force a specific model for title generation
          refresh_every_n_prompts = 3,
          max_refreshes = 3,
          format_title = nil, -- optional function to post-process the generated title
        },
        keymaps = {
          rename = { n = 'r', i = '<M-r>' },
          delete = { n = 'd', i = '<M-d>' },
          duplicate = { n = '<C-y>', i = '<C-y>' },
        },
      },
    })
  end,
}
