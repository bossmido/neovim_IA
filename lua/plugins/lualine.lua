local function executable_status()
  local file = vim.fn.expand('%:p')
  if vim.fn.filereadable(file) == 1 and vim.fn.executable(file) == 1 then
    return '🔒 +x'  -- or just '+x'
  end
  return ''
end


return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local auto_session_lib = require("auto-session.lib")
        local auto_session_enabled = false
        local buffers = 0
        local problems = 0
        local cached_problems = nil
        local timer = nil
        local severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN }

        vim.api.nvim_create_user_command("StatuslineSession", function()
            auto_session_enabled = not auto_session_enabled
        end, {})

        vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete", }, {
            callback = function()
                -- For some reason without `defer_fn` call to `getbufinfo` gets the wrong buffer count.
                vim.defer_fn(function()
                    buffers = #vim.fn.getbufinfo({ buflisted = 1 })
                end, 0)
            end
        })

        local update_problems_count = function()
            local errors = #vim.diagnostic.get(nil, { severity = severity })
            if vim.api.nvim_get_mode().mode == "i" then
                cached_problems = errors
            else
                problems = errors
                cached_problems = nil
            end
        end

        vim.api.nvim_create_autocmd("InsertLeave", {
            callback = function()
                if cached_problems then
                    problems = cached_problems
                    cached_problems = nil
                end
            end
        })

        vim.api.nvim_create_autocmd("DiagnosticChanged", {
            callback = function()
                if timer then
                    timer:stop()
                    timer:close()
                end

                timer = vim.uv.new_timer()
                if timer then
                    timer:start(500, 0, update_problems_count)
                else
                    vim.notify("Failed to set debounce timer.", vim.log.levels.WARN)
                    update_problems_count()
                end
            end,
        })

        require("lualine").setup({
            options = {
                refresh = {
                    statusline = 500,
                    tabline = 500,
                    winbar = 500,
                },
                globalstatus = false,
                -- component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                component_separators = { left = "›", right = "‹" },
                -- component_separators = "•",
            },
            sections = {
                lualine_a = {
                    {
                        "mode",
                        fmt = function(str)
                            return str:sub(1, 1)
                        end,
                    },
                },
                lualine_b = {
                    {
                        function()
                            if auto_session_enabled then
                                return auto_session_lib.current_session_name(true)
                            else
                                return ""
                            end
                        end
                    },
                    {
                        function()
                            if problems > 0 then
                                return problems
                            else
                                return ""
                            end
                        end,
                        icon = "",
                        color = function()
                            local color = vim.fn.synIDattr(vim.fn.hlID("DiagnosticError"), "fg")
                            if string.sub(color, 1, 1) ~= '#' then
                                color = "red"
                            end
                            return { fg = color }
                        end,
                        on_click = function()
                            require("telescope.builtin").diagnostics()
                        end
                    },
                    {
                        function() return buffers end,
                        icon = "",
                        on_click = function()
                            require("telescope.builtin").buffers()
                        end
                    },
                    'branch',
                    'diff',
                },
                lualine_c = {
                    {
                        "filename",
                        path = 1,
                    },
                },
                lualine_x = {
                    "diagnostics",
                    'filesize',
                    executable_status,
                    'fileformat',
                    {
                        "filetype",
                        icon_only = true,
                    }
                },
                lualine_y = {"progress"},
                lualine_z = {
                    "%l:%L"
                },
            }
        })
    end
}
