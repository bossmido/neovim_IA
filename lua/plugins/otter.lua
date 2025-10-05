

return { --* embed LSPs inside other filetypes *--
    "jmbuhr/otter.nvim",
    version="*",
    event="CmdlineEnter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",    
    "nvim-lspconfig",
    "hrsh7th/nvim-cmp"},
    opts = { 
        lsp = { 
            diagnostic_update_events = { "TextChanged" } 
        }, 
        buffers = {
            set_filetype = true,
            write_to_disk = true,
                ignore_pattern = {
      -- ipython cell magic (lines starting with %) and shell commands (lines starting with !)
      python = "^(%s*[%%!].*)",
  cpp = [[^%s*(#pragma|//).*]],
  },

        },
    },
        -- config = function()
        --     --require("otter").activate(languages, completion, true, tsquery) -- false: disable diagnostics
        -- end,
    }
