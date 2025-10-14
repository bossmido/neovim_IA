return {
  "Zeioth/compiler.nvim",
  cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo", "BuildAndDebug" },



  dependencies = {
    {
      "stevearc/overseer.nvim",
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
        vim.api.nvim_create_user_command("BuildAndDebug", function()
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

            vim.notify("🛠️ Compiling with gcc...", vim.log.levels.INFO)


            local result = vim.fn.system({ "gcc", "-g", file, "-o", binary })
            if vim.v.shell_error ~= 0 then

              vim.notify("❌ Build failed:\n" .. result, vim.log.levels.ERROR)


              return
            end

          end


          if vim.fn.filereadable(binary) == 0 then
            vim.notify("❌ Binary not found: " .. binary, vim.log.levels.ERROR)

            return
          end


          vim.notify("✅ Build complete → launching debugger...", vim.log.levels.INFO)




          ----------------------------------------------------------------

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


        vim.keymap.set({ "n", "i" }, "<F10>", ":BuildAndDebug<CR>",
          { desc = "Build and Debug current file" })

      end,
    },
    "nvim-telescope/telescope.nvim",


    "rcarriga/nvim-dap-ui",

    "mfussenegger/nvim-dap",

  },



  opts = {

    default_task_opts = {
      strategy = "background",
      cwd = vim.fn.getcwd(),

    },

    notify_on_complete = true,


    save_on_compile = true,
    jump_to_error = true,

  },

}



