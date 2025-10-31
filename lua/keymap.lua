
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
        vim.keymap.set({'i','n'}, "<c-p>", "<cmd>Telescope commands<CR>", { noremap = true, silent = true })

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
        ----------------------------------------------------------------------------
        vim.api.nvim_create_user_command('E', function()
            vim.fn['fzf#run']({
                source = 'fd --type f',
                sink = 'edit',
                options = '--prompt "Files> " --preview "bat --style=numbers --color=always --line-range :500 {}"'
            })
        end, {})

        vim.api.nvim_set_keymap(
            "n",
            "<C-LeftMouse>",
            ":normal! gf<CR>",
            { noremap = true, silent = true }
        )
        ------------------------------------------------------------------------------------------------------------
        vim.keymap.set('n', '<leader><leader>', '<C-^>', { desc = 'Toggle last buffer' })


        vim.keymap.set('i',"<C-j>", "<ESC>", { desc = 'Toggle last buffer' })
        ------------------------------------------------------------------------------------------------------------

        vim.keymap.set({'i',"n"},"<C-e>", "<ESC>:FzfLua<CR>", { desc = 'Toggle TOUT' })
        --------------------------------------------------------

        -- local on_attach = function(client, bufnr)
            --   vim.notify("LSP '" .. client.name .. "' attached to buffer " .. bufnr, vim.log.levels.INFO)
            -- end
            --
            --
            -- vim.keymap.set({'i',"n"},"<C-f>", function()
                -- local util = require("lspconfig.util")
                --
                -- vim.lsp.start({
                    --   name = "ts_ls",
                    --   cmd = { "typescript-language-server", "--stdio" },
                    --   root_dir = util.root_pattern("package.json", "tsconfig.json", ".git")(vim.api.nvim_buf_get_name(0)),
                    --   on_attach = function(client, bufnr)
                        --     vim.notify("ts_ls attaché au buffer " .. bufnr)
                        --   end,
                        -- })
                        --
                        -- end, { desc = 'Toggle TOUT' })

                        --

                        vim.keymap.set("n", "<leader>ts", "<cmd>:TermSelect<CR>")
                        vim.keymap.set("n", "<leader>tt", "<cmd>:ToggleTerm<CR>")
                        vim.keymap.set("n", "<leader>ta", "<cmd>:ToggleTermToggleAll<CR>")
                        vim.keymap.set("n", "<leader>th", "<cmd>:ToggleTerm direction=horizontal<CR>")
                        vim.keymap.set("n", "<leader>tv", "<cmd>:ToggleTerm direction=vertical size=100<CR>")
                        vim.keymap.set("n", "<leader>tf", "<cmd>:ToggleTerm direction=float<CR>")
                        vim.keymap.set("t", "<M-q>", "<cmd>:ToggleTerm<CR>")
vim.keymap.set("i", "<C-z>", "<esc>u", { desc = "Undo instead of suspend" })
vim.keymap.set("i", ":::", "<C-g>u<esc>:", { noremap = true, silent = true, desc = "Prevent ::: from triggering command mode" })
vim.keymap.set("n", "zz", ":qa<CR>", { desc = "Quit all and save" })
vim.keymap.set("n", "zq", ":qa!<CR>", { desc = "Quit all without saving" })



vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
    if #diagnostics > 0 then
      vim.b._has_bulb = true
    else
      vim.b._has_bulb = false
    end
  end,
})

vim.keymap.set('n', '<2-LeftMouse>', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.fn.line('.')
  local signs = vim.fn.sign_getplaced(bufnr, { lnum = lnum })[1].signs
  if signs and signs[1] and signs[1].name:match('LightBulb') then
    vim.lsp.buf.code_action()
  end
end, { desc = "Trigger code action when bulb sign clicked" })

