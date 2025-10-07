return {
    {
        "igorlfs/nvim-dap-view",
        ---@module 'dap-view'
        ---@type dapview.Config

        opts = {},
         keys = {
            { "<leader>d",  "", desc = "+debug", mode = { "n", "v" } },
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition" },
            { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
            { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
            { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
            { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },

            { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
            { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
            { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
            { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },

            { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
            { "<leader>dS", function() require("dap.ui.widgets").scopes() end, desc = "Scopes" },
            { "<leader>dI", function() require("dap.ui.widgets").hover() end, desc = "Variables" },
            { "<F5>", function()
                local dap = require("dap")
                if vim.fn.filereadable(".vscode/launch.json") == 1 then
                    require("dap.ext.vscode").load_launchjs(nil, { coreclr = { "cs" } })
                end
                dap.continue()
            end, desc = "Continue (F5)" },
        },

    },
}
