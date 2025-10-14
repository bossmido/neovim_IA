return {
  "Zeioth/compiler.nvim",
  cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" ,"BuildAndDebug"},
  dependencies = {
    {
      "stevearc/overseer.nvim",
      config = function()
        local overseer = require("overseer")
        local dap = require("dap")
        local dapui = require("dapui")


        overseer.setup()
        dapui.setup()


        -- Auto-open/close DAP UI
        dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
        dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
        dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end


        ----------------------------------------------------------------
        -- 💡 Command: build current file or project, then auto debug it
        ----------------------------------------------------------------
        vim.api.nvim_create_user_command("BuildAndDebug", function()
          local file = vim.fn.expand("%:p")               -- full path to current file
          local dir = vim.fn.fnamemodify(file, ":h")      -- directory of that file
          local binary = dir .. "/a.out"                  -- default output

          -- 🧱 Build step

          if vim.fn.filereadable(dir .. "/Makefile") == 1 then

            vim.notify("📦 Running make in " .. dir, vim.log.levels.INFO)
            vim.fn.system({ "make", "-C", dir })
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

          vim.notify("✅ Build complete → starting debugger...", vim.log.levels.INFO)


          -- 🐞 Configure DAP adapter
          dap.adapters.cppdbg = {
            id = "cppdbg",

            type = "executable",
            command = vim.fn.stdpath("data")
              .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
          }

          -- 🐞 DAP configuration per file
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


          dap.continue() -- 🚀 Start the debugger
        end, {})

        -- Keybinding (optional)
        vim.keymap.set("n", "<F9>", ":BuildAndDebug<CR>", { desc = "Build and Debug current file" })
      end,

    },
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    default_task_opts = {
      strategy = "background",

      cwd = vim.fn.getcwd(),
    },
    notify_on_complete = false,
    save_on_compile = true,
    jump_to_error = true,
  },
}
