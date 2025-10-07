return {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy", -- load lazily (after UI is ready)
  cmd = { "Telescope" },
  keys = { "<C-f>", "<C-g>" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "debugloop/telescope-undo.nvim",
    "nvim-telescope/telescope-frecency.nvim",
    "nvim-telescope/telescope-dap.nvim",
    "jvgrootveld/telescope-zoxide",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    },
  },

  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    -- --- 🪟 Windows-safe fnameescape fix
    local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
    local original_fnameescape = vim.fn.fnameescape
    local function win_fnameescape(path)
      local escaped = original_fnameescape(path)
      if is_windows then
        local need_extra_esc = path:find("[%[%]`%$~]")
        local esc = need_extra_esc and "\\\\" or "\\"
        escaped = escaped:gsub("\\[%(%)%^&;]", esc .. "%1")
        if need_extra_esc then
          escaped = escaped:gsub("\\\\['` ]", "\\%1")
        end
      end
      return escaped
    end
    local function select_default(prompt_bufnr)
      vim.fn.fnameescape = win_fnameescape
      local result = actions.select_default(prompt_bufnr, "default")
      vim.fn.fnameescape = original_fnameescape
      return result
    end

    -- 🪟 Auto-move help to right pane when wide enough
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "help",
      callback = function()
        if vim.fn.winwidth(0) > 200 then vim.cmd("wincmd L") end
      end,
    })

    -- 🧩 UI Helpers
    local function filename_first(_, path)
      local tail, parent = vim.fs.basename(path), vim.fs.dirname(path)
      return parent == "." and tail or string.format("%s\t\t%s", tail, parent)
    end
    local function set_width(percent, min)
      return function(_, max_columns)
        return math.max(math.floor(percent * max_columns), min)
      end
    end

    -- 📚 Highlight parent directory dimly
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "TelescopeResults",
      callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
          vim.fn.matchadd("TelescopeParent", "\t\t.*$")
          vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
        end)
      end,
    })

    -- 🔭 Setup Telescope
    telescope.setup({
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { preview_width = 0.55 },
        mappings = {
          i = { ["<CR>"] = select_default },
          n = {
            ["<CR>"] = select_default,
            ["q"] = actions.close,
          },
        },
      },
      pickers = {
        find_files = { path_display = filename_first },
        buffers = {
          theme = "dropdown",
          initial_mode = "normal",
          show_all_buffers = true,
          sort_lastused = true,
          previewer = false,
          mappings = { n = { ["dd"] = "delete_buffer" } },
          layout_config = { width = set_width(0.6, 120) },
        },
        quickfix = { initial_mode = "normal" },
        oldfiles = {
          theme = "dropdown",
          initial_mode = "normal",
          sort_lastused = true,
          previewer = false,
          layout_config = { width = set_width(0.6, 120) },
        },
        diagnostics = {
          theme = "ivy",
          path_display = filename_first,
          initial_mode = "normal",
          previewer = false,
        },
        lsp_references = { theme = "ivy", path_display = { "tail" }, initial_mode = "normal" },
        lsp_definitions = { theme = "ivy", path_display = { "tail" }, initial_mode = "normal" },
        lsp_implementations = { theme = "ivy", path_display = { "tail" }, initial_mode = "normal" },
      },
      extensions = {
        fzf = {},
        undo = {},
        zoxide = {
          prompt_title = "[ Walking on the shoulders of TJ ]",
          mappings = {
            default = {
              after_action = function(sel)
                print(("Updated to (%s) %s"):format(sel.z_score, sel.path))
              end,
            },
            ["<C-s>"] = {
              before_action = function() print("before C-s") end,
              action = function(sel) vim.cmd.edit(sel.path) end,
            },
          },
        },
        dap = {
          mappings = {
            default = {
              ["F9"] = {
                action = function() vim.cmd("Telescope dap commands") end,
              },
            },
          },
        },
      },
    })

    -- 🧩 Load extensions
    for _, ext in ipairs({ "fzf", "undo", "zoxide", "dap" }) do
      pcall(telescope.load_extension, ext)
    end

    -- 🎹 Keymaps
    local builtin = require("telescope.builtin")
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { desc = desc })
    end

    map("n", "<leader>fh", builtin.help_tags, "[F]uzzy [H]elp")
    map("n", "<leader>fk", builtin.keymaps, "[F]uzzy [K]eymaps")
    map("n", "<leader>ff", builtin.find_files, "[F]uzzy [F]iles")
    map("n", "<leader>fd", builtin.diagnostics, "[F]uzzy [D]iagnostics")
    map("n", "<leader>fr", builtin.resume, "[F]uzzy [R]esume")
    map("n", "<leader>fb", builtin.buffers, "[F]uzzy [B]uffers")
    map("n", "<leader>fo", builtin.oldfiles, "[F]uzzy [O]ld files")
    map("n", "<leader>fs", builtin.grep_string, "[F]uzzy [S]tring")
    map("n", "<leader>fq", builtin.quickfix, "[Q]uickfix")
    map("n", "<leader>f.", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        layout_config = { width = set_width(0.6, 120) },
        winblend = 10,
        previewer = false,
      }))
    end, "[.] Search current buffer")
    map("n", "<leader>fn", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, "[F]uzzy [N]eovim config")
    map("n", "<space>u", "<cmd>Telescope undo<CR>")
  end,
}
