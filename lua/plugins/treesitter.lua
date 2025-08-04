
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufReadPost",
        enabled = true,
        --event="VeryLazy",
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require('nvim-treesitter.configs').setup {
                -- A list of parser names, or "all" (the listed parsers MUST always be installed)
                ensure_installed = { "html","c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "http","php","javascript"},

                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = false,

                indent = {
                    enabled = true
                },

                highlight = {
                    enable = true,

                    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
                    disable = function(_, buf)
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        local max_filesize = 500 * 1024 -- 100 KB
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
            }
        end
    }
}
