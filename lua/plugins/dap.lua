------------------------------------------------------------
-- Ask user for args before running DAP
------------------------------------------------------------
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  config.args = function()
    local new_args = vim.fn.input("Run with args: ", table.concat(args, " "))
    return vim.split(vim.fn.expand(new_args), " ")
  end
  return config
end

return {
  -- 🔧 Compiler.nvim for running make/gcc
  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerRedo", "CompilerToggleResults" },
    dependencies = {
      {
        "stevearc/overseer.nvim",
        config = function()
             require("mason").setup()
    require("mason-nvim-dap").setup({
      ensure_installed = { "cppdbg" },
      automatic_installation = true,
    })
          local overseer = require("overseer")
          local dap = require("dap")
          local dapui = require("dapui")

          overseer.setup()
          dapui.setup()

          dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
          dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
          dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

          ------------------------------------------------------------
          -- Helper: detect debugger and project root
          ------------------------------------------------------------
          local debugger_path = vim.fn.exepath("gdb")
          local mi_mode = "gdb"
          if debugger_path == "" then
            debugger_path = vim.fn.exepath("lldb")
            mi_mode = "lldb"
          end
          if debugger_path == "" then
            vim.notify("❌ No GDB or LLDB found in PATH", vim.log.levels.ERROR)
            return
          end

          dap.adapters.cppdbg = {
            id = "cppdbg",
            type = "executable",
            command = vim.fn.stdpath("data")
              .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
          }

          local function get_project_root()
            local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
            if git_root and vim.fn.isdirectory(git_root) == 1 then
              return git_root
            end
            return vim.fn.getcwd()
          end

          ------------------------------------------------------------
          -- Command: build project (via compiler.nvim) + auto DAP
          ------------------------------------------------------------
          vim.api.nvim_create_user_command("BuildAndDebug", function()
            local project_root = get_project_root()
            local binary = project_root .. "/a.out"

            local function start_debug()
              if vim.fn.filereadable(binary) == 0 then
                vim.notify("❌ Binary not found: " .. binary, vim.log.levels.ERROR)
                return
              end

              vim.notify("🐞 Starting debugger on " .. binary, vim.log.levels.INFO)

              dap.configurations.cpp = {
                {
                  name = "Debug " .. vim.fn.fnamemodify(binary, ":t"),
                  type = "cppdbg",
                  request = "launch",
                  program = binary,
                  cwd = project_root,
                  stopAtEntry = false,
                  MIMode = mi_mode,
                  MIDebuggerPath = debugger_path,
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
              dap.continue({ before = get_args })
            end

            if vim.fn.filereadable(project_root .. "/Makefile") == 1 then
              vim.notify("📦 Building project (make -C " .. project_root .. ")", vim.log.levels.INFO)

              -- Run build using Overseer (compiler.nvim backend)
              overseer.new_task({
                cmd = { "make", "-C", project_root },
                components = { "default" },
                strategy = "terminal",
                on_exit = function(_, code)
                  if code == 0 then
                    vim.schedule(start_debug)
                  else
                    vim.notify("❌ Make failed.", vim.log.levels.ERROR)
                  end
                end,
              }):start()
            else
              vim.notify("⚙️ No Makefile found, compiling with g++...", vim.log.levels.INFO)

              overseer.new_task({
                cmd = { "g++", "-g", vim.fn.expand("%:p"), "-o", binary },
                components = { "default" },
                strategy = "terminal",
                on_exit = function(_, code)
                  if code == 0 then
                    vim.schedule(start_debug)
                  else
                    vim.notify("❌ g++ compilation failed.", vim.log.levels.ERROR)
                  end
                end,
              }):start()
            end
          end, {})

          vim.keymap.set("n", "<F9>", ":BuildAndDebug<CR>", { desc = "Build & Debug project" })
        end,
      },
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    opts = {
      default_task_opts = {
        strategy = "background",
      },
      notify_on_complete = false,
      save_on_compile = true,
      jump_to_error = true,
    },
  },
}

