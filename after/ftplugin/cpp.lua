vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp", "cc", "cxx", "hpp", "h" },
  callback = function()
    vim.keymap.set("i", "<CR>", function()
      local pos = vim.api.nvim_win_get_cursor(0)
      local row, col = pos[1], pos[2]
      local line = vim.api.nvim_get_current_line()
      local trimmed = line:gsub("%s+$", "")

      -- only modify if cursor is at end of line and no ;, {, }, :, , present
      if col == #line and not trimmed:match("[;{}:,]%s*$") and trimmed ~= "" then
        vim.schedule(function()
          vim.api.nvim_buf_set_text(0, row - 1, #line, row - 1, #line, { ";" })
        end)
      end

      -- simulate Enter key normally (without expr mode)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)

    end, { buffer = true })
  end,
})
