-- :bd          - deletes the current buffer, error if there are unwritten changes
-- :bd!         - deletes the current buffer, no error if unwritten changes
-- :bufdo bd    - deletes all buffers, stops at first error (unwritten changes)
-- :bufdo! bd   - deletes all buffers except those with unwritten changes
-- :bufdo! bd!  - deletes all buffers, no error on any unwritten changes
--
-- :bw          - completely deletes the current buffer, error if there are unwritten changes
-- :bw!         - completely deletes the current buffer, no error if unwritten changes
-- :bufdo bw    - completely deletes all buffers, stops at first error (unwritten changes)
-- :bufdo! bw   - completely deletes all buffers except those with unwritten changes
-- :bufdo! bw!  - completely deletes all buffers, no error on any unwritten changes
--
-- :set confirm - confirm changes (Yes, No, Cancel) instead of error
--
-- :ls          - list open buffers
-- :b N         - open buffer number N (as shown in ls)
-- :tabe +Nbuf  - open buffer number N in new tab
-- :bnext       - go to the next buffer (:bn also)
-- :bprevious   - go to the previous buffer (:bp also)

return {
    "akinsho/bufferline.nvim",
    -- enabled = false,
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        local bufferline = require("bufferline")
        bufferline.setup {
            options = {
                mode = "buffers",
                style_preset = bufferline.style_preset.no_italic,
                -- tab_size = 14,
                numbers = "buffer_id",
                diagnostics = "nvim_lsp",
                offsets = {
                    text_align = "left",
                },
                show_buffer_icons = false,
                show_buffer_close_icons = false,
                diagnostics_indicator = function(_, level, _, _)
                    local icon = level:match("error") and " " or level:match("warning") and " " or ""
                    return icon
                end
            }
        }
    end
}
