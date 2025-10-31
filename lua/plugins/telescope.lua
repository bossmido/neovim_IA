return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  keys = {
    { "<C-f>", desc = "Telescope: Find All Menu" },
    { "<C-g>", desc = "Telescope: Find Files (root)" },
    { "<C-s>", desc = "Telescope: Grep word under cursor" },
    { "<C-d>", desc = "Telescope: Workspace Symbols" },
    { "<F9>",  desc = "Telescope: DAP Commands" },
    { "<F11>", desc = "Open Floaterminal" },
    { "<F12>", desc = "Open TermNew" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-frecency.nvim",
    "debugloop/telescope-undo.nvim",
    "jvgrootveld/telescope-zoxide",
    "nvim-telescope/telescope-dap.nvim",
  },

  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { preview_width = 0.55 },
        mappings = {
          i = { ["<esc>"] = actions.close },
          n = { ["q"] = actions.close },
        },
      },
      pickers = {
        find_files = { hidden = true, no_ignore = true },
        buffers = { theme = "dropdown", previewer = false },
      },
      extensions = {
        fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true },
        frecency = {},
        undo = {},
        zoxide = {},
        dap = {},
      },
    })

    -- load all extensions safely
    for _, ext in ipairs({ "fzf", "frecency", "undo", "zoxide", "dap" }) do
      pcall(telescope.load_extension, ext)
    end

    --------------------------------------------------------------------
    -- 🧭 Custom "Find All" Menu
    --------------------------------------------------------------------
    local pickers_mod = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values

    local function find_all_menu()
      pickers_mod.new({}, {
        prompt_title = "Find All",
        finder = finders.new_table({
          results = {
            "Find Files",
            "Git Files",
            "Buffers",
            "Help Tags",
            "Live Grep",
            "Sessions",
            "Projects",
            "Zoxide",
          },
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          local function on_choice()
            local selection = require("telescope.actions.state").get_selected_entry()
            actions.close(prompt_bufnr)
            local builtin = require("telescope.builtin")
            if selection[1] == "Find Files" then
              builtin.find_files({ hidden = true, no_ignore = true })
            elseif selection[1] == "Git Files" then
              builtin.git_files()
            elseif selection[1] == "Buffers" then
              builtin.buffers()
            elseif selection[1] == "Help Tags" then
              builtin.help_tags()
            elseif selection[1] == "Live Grep" then
              builtin.live_grep()
            elseif selection[1] == "Sessions" then
              vim.cmd("Telescope possession list")
            elseif selection[1] == "Projects" then
              vim.cmd("Telescope projects projects")
            elseif selection[1] == "Zoxide" then
              vim.cmd("Telescope zoxide list")
            end
          end
          map("i", "<CR>", on_choice)
          map("n", "<CR>", on_choice)
          return true
        end,
      }):find()
    end

    --------------------------------------------------------------------
    -- 🧩 Keymaps
    --------------------------------------------------------------------
    local map = vim.keymap.set
    local builtin = require("telescope.builtin")

    -- Custom menu
    map({ "n", "i" }, "<C-f>", find_all_menu, { desc = "Telescope: Find All Menu" })

    -- DAP
    map({ "n", "i" }, "<F9>", "<ESC>:Telescope dap commands<CR>", { desc = "Telescope: DAP Commands", silent = true })

    -- Terminal helpers
    map({ "n", "i" }, "<F12>", "<ESC>:TermNew<CR>", { desc = "Toggle Terminal" })
    map({ "n", "i", "c" }, "<F11>", "<ESC>:Floaterminal<CR>", { desc = "Floating Terminal" })

    -- Search word under cursor
    map("n", "<C-s>", function()
      builtin.grep_string({ search = vim.fn.expand("<cword>") })
    end, { desc = "Telescope: Grep Current Word", noremap = true, silent = true })

    -- Workspace symbols
    map("n", "<C-d>", builtin.lsp_workspace_symbols, { desc = "Telescope: Workspace Symbols" })

    -- Quickfix navigation
    map("n", "<leader>q", ":copen<CR>", { desc = "Open Quickfix List" })
    map("n", "]q", ":cnext<CR>", { desc = "Next Quickfix Item" })
    map("n", "[q", ":cprev<CR>", { desc = "Previous Quickfix Item" })

    -- Root-level find
    map({ "n", "i" }, "<C-g>", function()
      builtin.find_files({ cwd = "/" })
    end, { desc = "Telescope: Find Files from Root", noremap = true, silent = true })

    -- OS-aware live grep across home
    local home = vim.loop.os_uname().sysname == "Windows_NT" and "C:/Users" or "/home"
    vim.api.nvim_set_keymap(
      "i",
      "<C-S-g>",
      ':lua require("telescope.builtin").live_grep({ cwd = "'
        .. home
        .. '", additional_args = function() return { "--hidden", "--glob", "!.git/*" } end })<CR>',
      { noremap = true, silent = true, desc = "Telescope: Live Grep Home" }
    )
  end,
}
