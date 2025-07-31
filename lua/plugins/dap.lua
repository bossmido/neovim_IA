return {
    "mfussenegger/nvim-dap",
    dependencies = {
        { "rcarriga/nvim-dap-ui", config = true },
{"nvim-neotest/nvim-nio",lazy = true}    },
    config = function()
        local dap = require("dap")

        -- LLDB config for C and C++
        dap.adapters.lldb = {
            type = "executable",
            command = "/usr/bin/lldb-vscode", -- Adjust this path if needed
            name = "lldb"
        }

        dap.configurations.cpp = {
            {

                name = "Launch file",
                type = "lldb",
                request = "launch",

                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,

                args = {},
            },
        }

        -- Use same config for C

        dap.configurations.c = dap.configurations.cpp
        -- PHP adapter using xdebug
        dap.adapters.php = {
            type = "executable",
            command = "node",
            args = { "/path/to/vscode-php-debug/out/phpDebug.js" },
        }

        dap.configurations.php = {
            {

                type = "php",

                request = "launch",
                name = "Listen for Xdebug",
                port = 9003,
                pathMappings = {
                    ["/var/www/html"] = "${workspaceFolder}",
                },
            },
        }
        --
        -- -- UI optional
        -- local dapui = require("dapui")
        -- dap.listeners.after.event_initialized["dapui_config"] = function()
            --   dapui.open()
            -- end
            -- dap.listeners.before.event_terminated["dapui_config"] = function()
                --   dapui.close()
                -- end
                -- dap.listeners.before.event_exited["dapui_config"] = function()
                    --   dapui.close()
                    -- end
                end
            }
