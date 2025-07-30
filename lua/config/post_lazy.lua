--test
local luasnip = require("luasnip")

luasnip.config.set_config({
    -- Use bordered windows with rounded corners
    ext_opts = {
        [require("luasnip.util.types").choiceNode] = {
            active = {
                virt_text = { { "●", "GruvboxGreen" } }, -- or other marker
                hl_group = "Visual",
                -- set window options for floating windows:

                winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                border = "rounded",
            },
        },
    },
})
-------------------------------------------------------------------------
require("notify").setup({
    -- Make sure stages support multiline
    stages = "fade_in_slide_out",
    -- or try "slide" or "fade"
    max_width = 110,    -- adjust width if needed
    max_height = 50000, -- adjust height if needed
})
------------------------------------------------------------------------
local cmp = require('cmp')
local luasnip = require('luasnip')
local copilot = require('copilot.suggestion') -- assuming copilot lua API

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

vim.api.nvim_set_keymap('i', '<Tab>', [[luaeval("require'my_tab_complete'()")]], { expr = true, noremap = true })

-- In a separate Lua file or inside your config, define the function
_G.my_tab_complete = function()
    if cmp.visible() then
        return cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
        return '<Plug>luasnip-expand-or-jump'
    elseif copilot.is_visible() then
        return copilot.accept() -- or your copilot accept function
    elseif has_words_before() then
        return cmp.complete()
    else
        return '\t'
    end
end
