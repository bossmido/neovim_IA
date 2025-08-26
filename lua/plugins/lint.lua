return {
  "mfussenegger/nvim-lint",
  config = function()
    local lint = require("lint")

    -- Define LanguageTool (French)
    lint.linters.languagetool_fr = {
      cmd = "languagetool",
      stdin = true,
      args = { "--language", "fr", "--json", "-" },
      stream = "stdout",
      ignore_exitcode = true,
      parser = function(output, _)
        local results = {}
        local ok, decoded = pcall(vim.fn.json_decode, output)
        if not ok or not decoded or not decoded.matches then
          return results
        end

        for _, match in ipairs(decoded.matches) do
          local message = match.message
          local offset = match.offset
          local length = match.length

          -- fallback to position 0 (line 0, col 0)
          local row = 0
          local col = 0

          table.insert(results, {
            lnum = row,
            col = col,
            end_lnum = row,
            end_col = col + length,
            severity = vim.diagnostic.severity.WARN,
            message = message,
            source = "languagetool",
          })
        end

        return results
      end,
    }

    -- Enable for these filetypes
    lint.linters_by_ft = {
      markdown = { "languagetool_fr" },
      text = { "languagetool_fr" },
    }

    -- Trigger on save
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })

    -- Define the :Lint command manually (optional but handy)
    vim.api.nvim_create_user_command("Lint", function()
      require("lint").try_lint()
    end, {})
  end,
}

