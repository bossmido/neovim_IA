local function get_args(config)
    local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
    config = vim.deepcopy(config)
    ---@cast args string[]
    config.args = function()
        local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
        return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
    end
    return config
end


return {
    {
        "mfussenegger/nvim-dap",
        --        event = "CmdlineEnter", -- cond = vim.g.dotfile_config_type ~= "minimal",
        dependencies = {
            -- { "igorlfs/nvim-dap-view", opts = {} },
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",

            -- "nvim-neotest/nvim-nio",
            -- "nvim-telescope/telescope-dap.nvim",
        },
        lazy = true,

        -- priority = 100,

        -- stylua: ignore
        keys = {

            { "<leader>d",  "",                                                                                                                                                                                                              desc = "+debug",                 mode = { "n", "v" } },
            { "<leader>dB", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",                                                                                                                            desc = "Breakpoint Condition" },
            { "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>",                                                                                                                                                               desc = "Toggle Breakpoint" },
            { "<leader>da", "<cmd>lua require('dap').continue({ before = get_args })<cr>",                                                                                                                                                   desc = "Run with Args" },
            { "<leader>dC", "<cmd>lua require('dap').run_to_cursor()<cr>",                                                                                                                                                                   desc = "Run to Cursor" },
            { "<leader>dg", "<cmd>lua require('dap').goto_()<cr>",                                                                                                                                                                           desc = "Go to Line (No Execute)" },

            { "<leader>di", "<cmd>lua require('dap').step_into()<cr>",                                                                                                                                                                       desc = "Step Into" },
            { "<leader>dj", "<cmd>lua require('dap').down()<cr>",                                                                                                                                                                            desc = "Down" },
            { "<leader>dk", "<cmd>lua require('dap').up()<cr>",                                                                                                                                                                              desc = "Up" },
            { "<leader>dl", "<cmd>lua require('dap').run_last()<cr>",                                                                                                                                                                        desc = "Run Last" },
            { "<leader>do", "<cmd>lua require('dap').step_out()<cr>",                                                                                                                                                                        desc = "Step Out" },
            { "<leader>dO", "<cmd>lua require('dap').step_over()<cr>",                                                                                                                                                                       desc = "Step Over" },
            { "<leader>dp", "<cmd>lua require('dap').pause()<cr>",                                                                                                                                                                           desc = "Pause" },
            { "<leader>dr", "<cmd>lua require('dap').repl.toggle()<cr>",                                                                                                                                                                     desc = "Toggle REPL" },
            { "<leader>ds", "<cmd>lua require('dap').session()<cr>",                                                                                                                                                                         desc = "Session" },
            { "<leader>dt", "<cmd>lua require('dap').terminate()<cr>",                                                                                                                                                                       desc = "Terminate" },

            { "<leader>dw", "<cmd>lua require('dap.ui.widgets').hover()<cr>",                                                                                                                                                                desc = "Widgets" },
            { "<F5>",       "<cmd>lua local continue = function() if vim.fn.filereadable('.vscode/launch.json') then require('dap.ext.vscode').load_launchjs(nil, { coreclr = { 'cs' } }) end require('dap').continue() end continue()<cr>", desc = "Continue (F5)" },
            {
                "<leader>dI",
                "<cmd>lua require('dap.ui.widgets').hover()<cr>",

                desc = "Variables",
            },
            {
                "<leader>dS",
                "<cmd>lua require('dap.ui.widgets').scopes()<cr>",
                desc = "Scopes",
            },
        },
        config = function()

            -- require("telescope").load_extension("dap")
            -- require("dap.ext.vscode").load_launchjs()
            local dap=require("dap")
------------------------------------------------------------

-- 🧠  Detect debugger automatically and configure cppdbg
------------------------------------------------------------
local dap = require("dap")

-- find gdb or lldb on the system

local debugger_path = vim.fn.exepath("gdb")
local mi_mode = "gdb"


if debugger_path == "" then
  debugger_path = vim.fn.exepath("lldb")
  mi_mode = "lldb"
end

if debugger_path == "" then
  vim.notify("❌ No GDB or LLDB found in PATH", vim.log.levels.ERROR)
else
  dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = vim.fn.stdpath("data")
      .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
  }

  dap.configurations.cpp = {
    {
      name = "Auto-detect debugger",
      type = "cppdbg",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/a.out", "file")
      end,
      cwd = "${workspaceFolder}",
      stopAtEntry = false,

      -- 🔍 automatically detected
      MIMode = mi_mode,
      MIDebuggerPath = debugger_path,

      setupCommands = {
        {
          text = "-enable-pretty-printing",
          description = "Enable pretty printing",
          ignoreFailures = false,
        },
      },
    },
  }
  dap.configurations.c = dap.configurations.cpp

end
            dap.adapters.cppdbg = {
                id = "cppdbg",
                type = "executable",
                command = "/home/aur/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
            }

            require("nvim-dap-virtual-text").setup({
                highlight_new_as_changed = true,
            })

            vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

            local vscode = require("dap.ext.vscode")

            local json = require("plenary.json")
            vscode.json_decode = function(str)
                return vim.json.decode(json.json_strip_comments(str))
            end

            -- dap.configurations.cs = {
                -- 	{
                    -- 		type = "coreclr",
                    -- 		request = "launch",
                    -- 		name = "launch - codageauto",
                    -- 		program = "./bin/Debug/net7.0/siemenscodageauto.dll",
                    -- 	},
                    -- }

                    local sign = vim.fn.sign_define

                    sign("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "red" })
                    sign(
                        "DapBreakpointRejected",
                        { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "red" }
                    )
                    sign(
                        "DapBreakpointCondition",
                        { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "red" }
                    )
                    sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
                    sign("DapStopped", { text = "󰧂", texthl = "DapStopped", linehl = "", numhl = "" })

                    -- local dap, dapview = require("dap"), require("dap-view")
                    -- dap.listeners.after.event_initialized["dapview-config"] = function()
                        -- 	dapview.open()
                        --
                        -- 	vim.keymap.set(
                            -- 		"n",

                            -- 		"<leader><leader>",
                            -- 		"<cmd>lua require('dap').step_over()<cr>",
                            -- 		{ noremap = true, silent = true }
                            -- 	)
                            -- end
                            -- dap.listeners.before.event_terminated["dapview-config"] = function()
                                -- 	dapview.close()

                                -- 	vim.keymap.del("n", "<leader><leader>")
                                -- end
                                -- dap.listeners.before.event_exited["dapview-config"] = function()
                                    -- 	dapview.close()
                                    -- end
                                end,
                            },
                            {
                                "mfussenegger/nvim-jdtls",
                                dependencies = { "mfussenegger/nvim-dap" },
                                ft = { "java" },
                                event = "VeryLazy",

                            }
                        }

