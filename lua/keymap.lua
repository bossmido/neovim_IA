vim.keymap.set("n", "<leader>w", "<cmd>write<CR>")
-- vim.keymap.set("n", "<leader>wa", "<cmd>wall<CR>")
vim.keymap.set("n", "<C-S>", "<cmd>write<CR>")
vim.keymap.set("i", "<C-S>", "<cmd>write<CR>")
vim.keymap.set("n", "<M-S>", "<cmd>wall<CR>")
vim.keymap.set("i", "<M-S>", "<cmd>wall<CR>")

vim.keymap.set("n", "<leader>R", "<cmd>edit<CR>")

vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>")

vim.keymap.set("n", "<leader>F", vim.lsp.buf.format)
vim.keymap.set("n", "<M-F>", vim.lsp.buf.format)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")
-- vim.keymap.set("n", "<leader>d", "\"_d")
-- vim.keymap.set("v", "<leader>d"d "\"_d")
-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":lua<CR>")

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")
vim.keymap.set("i", "jj", "<Esc>")

-- vim.keymap.set("n", "<space>tf", "<cmd>PlenaryBustedFile %<CR>")

-- <Reddit>
vim.keymap.set("n", "ycc", "yygccp", { remap = true })

vim.keymap.set("x", "/", "<Esc>/\\%V");

-- Automatically add semicolon or comma at the end of the line in INSERT and NORMAL modes
vim.keymap.set("i", ";;", "<ESC>A;")
vim.keymap.set("i", ",,", "<ESC>A,")
vim.keymap.set("n", ";;", "A;<ESC>")
vim.keymap.set("n", ",,", "A,<ESC>")
-- </Reddit>

local buffer_command = function(command)
    -- if vim.bo.buftype == "nofile" then
    --     return
    -- end

    if #vim.fn.getbufinfo({ buflisted = 1 }) == 0 then
        print "No buffers found."
        return
    end

    vim.cmd(command)
end

vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { desc = "[D]iagnostics" })
vim.keymap.set('n', '<leader>dl', function()
    local vl_enabled = vim.diagnostic.config().virtual_lines == true
    vim.diagnostic.config({
        virtual_lines = not vl_enabled,
        virtual_text = vl_enabled
    })
end, { desc = 'Toggle diagnostic virtual lines' })

vim.keymap.set("n", "<leader>n", function() buffer_command("bnext") end)
vim.keymap.set("n", "<leader>p", function() buffer_command("bprev") end)

--vim.keymap.set("n", "<C-n>", function() buffer_command("bnext") end)
--vim.keymap.set("n", "<C-p>", function() buffer_command("bprev") end)

-- vim.keymap.set("n", "<leader>dd", function()
vim.keymap.set("n", "<leader>bd", function()
    if vim.bo.buftype == "terminal" then
        vim.cmd("bd!")
    else
        -- local buffers = vim.api.nvim_list_bufs()
        -- local current = vim.api.nvim_get_current_buf()
        --
        -- for _, buf in ipairs(buffers) do
        --     if buf ~= current and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype ~= "nofile" then
        --         vim.api.nvim_set_current_buf(buf) -- Switch to the next buffer
        --     end
        -- end
        -- vim.cmd("bd " .. current)
        vim.cmd("bd")
    end
end, { desc = "Unload buffer and delete it from the buffer list." })

-- vim.keymap.set("n", "<leader>st", function()
--     vim.cmd.vnew()
--     vim.cmd.term()
--     vim.cmd.wincmd("J")
--     vim.api.nvim_win_set_height(0, 15)
-- vim.api.nvim_command("startinsert")
-- vim.cmd("startinsert")
-- end)

-- vim.api.nvim_set_keymap('i', '"', '""<Left>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', "'", "''<Left>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '(', '()<Left>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '[', '[]<Left>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '{', '{}<Left>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '{<CR>', '{<CR>}<ESC>O', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '{;<CR>', '{<CR>};<ESC>O', { noremap = true, silent = true })



-- ME MIENS

vim.keymap.set("x", "<leader>re", ":Refactor extract ")
vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")


vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")

vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")


vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")

vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")

vim.keymap.set('i', '<C-p>', function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>:', true, false, true), 'n', false)
end, { noremap = true })
vim.keymap.set('n', '<C-p>', ':', { noremap = true, expr = false })


vim.keymap.set("n", "<C-a>", function()
    local aerial = require("aerial")
    if aerial.is_open() then
        aerial.close()
    else
        aerial.open()
        aerial.nav_to_symbol({ jump = true })
    end
end, { desc = "Aerial: Toggle and jump to symbol" })




local actions = require('telescope.actions')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values

local function find_all_menu()
    pickers.new({}, {
        prompt_title = "Find All",
        finder = finders.new_table({
            results = {
                "Find Files",
                "Git Files",
                "Buffers",
                "Help Tags",
                "Live Grep",
                "Sessions",
                "Projets",
                "Zoxide"
            }
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            local function on_choice()
                local selection = require('telescope.actions.state').get_selected_entry()
                actions.close(prompt_bufnr)
                if selection[1] == "Find Files" then
                    require('telescope.builtin').find_files({ hidden = true, no_ignore = true })
                elseif selection[1] == "Git Files" then
                    require('telescope.builtin').git_files()
                elseif selection[1] == "Buffers" then
                    require('telescope.builtin').buffers()
                elseif selection[1] == "Help Tags" then
                    require('telescope.builtin').help_tags()
                elseif selection[1] == "Live Grep" then
                    require('telescope.builtin').live_grep()
                elseif selection[1] == "Sessions" then
                    selection[1] = "possession list"
                    vim.cmd("Telescope possession list")
                    --require('telescope.builtin').live_grep()
                elseif selection[1] == "Projets" then
                    selection[1] = "Projets"
                    vim.cmd("Telescope projects projects")
                elseif selection[1] == "Zoxide" then
                    selection[1] = "Zoxide"
                    vim.cmd("Telescope zoxide list")
                end
            end
            map('i', '<CR>', on_choice)
            map('n', '<CR>', on_choice)
            return true
        end,
    }):find()
end

vim.keymap.set({"n","i"}, "<F9>", "<ESC>:Telescope dap commands<CR>", { desc = "Telescope: debug avec le DAP" })
vim.keymap.set({"n","i"}, "<C-f>", find_all_menu, { desc = "Telescope: Find All Menu" })
--vim.keymap.set("i", "<C-f>", find_all_menu, { desc = "Telescope: Find All Menu" })

vim.keymap.set("n", "<F12>", ":ToggleTerm<CR>", { desc = "ouvre le putain de terminal" })
vim.keymap.set("i", "<F12>", "<ESC>:ToggleTerm<CR>", { desc = "ouvre le putain de terminal" })

vim.keymap.set('n', '<C-s>', function()
    require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>") })
end, { noremap = true, silent = true })


vim.keymap.set("n", "<C-d>", function()
    require("telescope.builtin").lsp_workspace_symbols()
end, { desc = "Telescope: Workspace Symbols" })
vim.keymap.set('n', '<leader>q', ':copen<CR>', { desc = 'Open Quickfix List' })
vim.keymap.set('n', ']q', ':cnext<CR>', { desc = 'Next Quickfix Item' })
vim.keymap.set('n', '[q', ':cprev<CR>', { desc = 'Previous Quickfix Item' })

vim.keymap.set(
    'n',
    '<C-g>',
    "<cmd>lua require('telescope.builtin').find_files({ cwd = '/' })<CR>",
    { noremap = true, silent = true }
)


local home = vim.loop.os_uname().sysname == "Windows_NT"
    and "C:/Users"

    or "/home"


vim.api.nvim_set_keymap('i', '<C-S-g>',
    ':lua require("telescope.builtin").live_grep({   cwd = "' ..
    home ..
    '",   additional_args = function()     return { "--hidden", "--glob", "!.git/*" }   end })<CR>',
    { noremap = true, silent = true })


    -- Open compiler
vim.api.nvim_set_keymap('n', '<F6>', "<cmd>CompilerOpen<cr>", { noremap = true, silent = true })

-- Redo last selected option
vim.api.nvim_set_keymap('n', '<S-F6>',
     "<cmd>CompilerStop<cr>" -- (Optional, to dispose all tasks before redo)
  .. "<cmd>CompilerRedo<cr>",
 { noremap = true, silent = true })

-- Toggle compiler results
vim.api.nvim_set_keymap('n', '<S-F7>', "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('c', '<C-f>', "<cmd>lua require('telescope.builtin').command_history()<CR>", { noremap = true, silent = true })

vim.api.nvim_create_user_command("E", function()
  require("telescope.builtin").find_files()
end, {})
-----------------------------------------------------------------
---
----- Keyboard users
-- mouse users + nvimtree users!
vim.keymap.set({ "n", "v","i" }, "<RightMouse>", function()
  require('menu.utils').delete_old_menus()

--  vim.cmd.exec '"normal! \\<RightMouse>"'
--pcall(vim.cmd, [[normal! \\<RightMouse>]])
  -- clicked buf
  local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
--  local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

  require("menu").open("default", { mouse = true })
end, {})
