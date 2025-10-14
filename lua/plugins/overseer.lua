return {"stevearc/overseer.nvim",

            config = function()
                local overseer = require("overseer")
                local dap = require("dap")
                local dapui = require("dapui")

                overseer.setup()
                dapui.setup()

                --------------------------------------------------------------------
                -- 🪟 DAP UI Auto-open / Auto-close
                --------------------------------------------------------------------
                -- Always reattach listeners cleanly
                dap.listeners.after.event_initialized["dapui_config"] = function()


                    dapui.open()

                    vim.notify("🐞 Debug session started — DAP UI opened", vim.log.levels.INFO)



                end

                dap.listeners.before.event_terminated["dapui_config"] = function()

                    dapui.close()
                    vim.notify("🛑 Debug session terminated", vim.log.levels.INFO)
                end


                dap.listeners.before.event_exited["dapui_config"] = function()

                    dapui.close()
                    vim.notify("👋 Debug session exited", vim.log.levels.INFO)
                end


                --------------------------------------------------------------------

                -- 💡 Build & Debug Command
                --------------------------------------------------------------------

                vim.api.nvim_create_user_command("CompilerTest", function()
                    vim.notify("test")
                end,{})


                vim.api.nvim_create_user_command("CompilerDebug", function()
                    local file = vim.fn.expand("%:p")          -- full path
                    local dir = vim.fn.fnamemodify(file, ":h") -- file directory
                    local binary = dir .. "/a.out"             -- default output binary




                    -- 🧱 Build step
                    if vim.fn.filereadable(dir .. "/Makefile") == 1 then

                        vim.notify("🧹 Cleaning project...", vim.log.levels.INFO)


                        vim.fn.system({ "make", "-C", dir, "clean" })

                        vim.notify("📦 Building with make...", vim.log.levels.INFO)


                        vim.fn.system({ "make", "-C", dir, "debug" })





                    else


                        vim.notify("🛠️ Compiling directly with gcc...", vim.log.levels.INFO)



                    end


                    vim.notify("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.", vim.log.levels.INFO)



                    if vim.fn.filereadable(binary) == 0 then

                        vim.notify("❌ Binary not found: " .. binary, vim.log.levels.ERROR)

                                                vim.fn.system({ "make", "-C", dir, "" })

                    end



                    vim.notify("✅ Build complete → launching debugger...", vim.log.levels.INFO)





                    -------------------gg---------------------------------------------


                    -- 🐞 Configure DAP adapter (once only)
                    ----------------------------------------------------------------
                    if not dap.adapters.cppdbg then

                        dap.adapters.cppdbg = {
                            id = "cppdbg",


                            type = "executable",




                            command = vim.fn.stdpath("data")
                            .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
                        }
                    end





                    dap.configurations.cpp = {


                        {
                            name = "Auto Debug " .. vim.fn.fnamemodify(file, ":t"),

                            type = "cppdbg",

                            request = "launch",


                            program = binary,
                            cwd = dir,
                            stopAtEntry = false,

                            setupCommands = {
                                {

                                    text = "-enable-pretty-printing",

                                    description = "Enable GDB pretty printing",

                                    ignoreFailures = false,


                                },

                            },

                        },
                    }
                    dap.configurations.c = dap.configurations.cpp


                    -- 🚀 Start the debugger
                    require("dap").continue()
                end, {})

                --------------------------------------------------------------------
                -- ⌨️ Keybinding


                --------------------------------------------------------------------




                vim.keymap.set({ "n", "i" }, "<F10>", ":CompilerDebug<CR>",
                { desc = "Build and Debug current file" })

            end,

        }




