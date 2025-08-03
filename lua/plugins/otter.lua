
return { --* embed LSPs inside other filetypes *--
    "jmbuhr/otter.nvim",
    version="*",
    ft={"html"}
    event="CmdlineEnter",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = { 
        lsp = { 
            diagnostic_update_events = { "TextChanged" } 
        }, 
        buffers = {
            set_filetype = true,
            write_to_disk = true,
        },},
        config = function()
            --  require("otter").activate(languages, completion, true, tsquery) -- false: disable diagnostics
        end,
    }
