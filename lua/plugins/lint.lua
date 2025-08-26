{
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
          local offset = match.offset or 0
          local length = match.length or 1

          table.insert(results, {
            lnum = 0,
            col = offset,
            end_lnum = 0,
            end_col = offset + length,
            severity = vim.diagnostic.severity.WARN,
            message = message,
            source = "languagetool",
          })
        end

        return results
      end,
    }

    -- Assign LanguageTool to filetypes
    lint.linters_by_ft = {
      markdown = { "languagetool_fr" },
      text = { "languagetool_fr" },
    }

    -- Run linter on text change, insert leave, and save
    vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })

    -- Optional: Add :Lint command
    vim.api.nvim_create_user_command("Lint", function()
      require("lint").try_lint()
    end, {})
  end,
}

