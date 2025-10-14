return {"stevearc/overseer.nvim",

            config = function()
                local overseer = require("overseer")
                local dap = require("dap")
                local dapui = require("dapui")

                overseer.setup()
                dapui.setup()

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.c", "*.cpp", "*.cc", "*.cxx" },
  callback = function()
    local file = vim.fn.expand("%:p")
    local ext = vim.fn.expand("%:e")
    local dir = vim.fn.fnamemodify(file, ":h")
    local root = dir

    -- 🔍 Find project root
    while root ~= "/" do
      if vim.fn.filereadable(root .. "/Makefile") == 1 or vim.fn.isdirectory(root .. "/.git") == 1 then
        break
      end
      root = vim.fn.fnamemodify(root, ":h")
    end


    -- 🧱 Build command
    local cmd
    local binary = "/tmp/" .. vim.fn.expand("%:t:r")
    if vim.fn.filereadable(root .. "/Makefile") == 1 then

      vim.notify("📦 Found Makefile → running make", vim.log.levels.INFO)
      cmd = { "make", "-C", root }
    else

      local compiler = (ext == "c") and "gcc" or "g++"
      vim.notify("🛠️ Compiling directly with " .. compiler, vim.log.levels.INFO)
      cmd = { compiler, "-Wall", "-g", file, "-o", binary }
    end


    -- 🚀 Start async Overseer task

    local task = overseer.new_task({
      name = "Auto Build " .. vim.fn.expand("%:t"),
      cmd = cmd,
      strategy = {
        "terminal",
        direction = "float",
        close_on_exit = false,
      },
      components = {
        { "on_exit_set_status", success_codes = { 0 } },
        "default",
      },
    })

    -- 🔔 Notify when build completes
    task:subscribe("on_complete", function(_, status)

      if status == "SUCCESS" then
        vim.notify("✅ Build succeeded for " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
      else
        vim.notify("❌ Build failed for " .. vim.fn.expand("%:t"), vim.log.levels.ERROR)
      end

    end)

    task:start()

  end,
})
                --------------------------------------------------------------------
                -- 🪟 DAP UI Auto-open / Auto-close
                --------------------------------------------------------------------
                -- Always reattach listeners cleanly
                dap.listeners.after.event_initialized["dapui_config"] = function()

dap.terminate()
  dapui.close()
   os.execute("pkill gdb")
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
vim.api.nvim_create_user_command("ValgrindRun", function()
  local bin = vim.fn.expand("%:p:h") .. "/a.out"
  vim.cmd("botright split | terminal valgrind --leak-check=full " .. bin)
end, { desc = "Run Valgrind on current binary" })

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




