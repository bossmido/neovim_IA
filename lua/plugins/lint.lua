return  {
    'mfussenegger/nvim-lint',
    config = function()
      local lint = require('lint')

      lint.linters.harper = {
        cmd = 'harper',
        stdin = true,
        args = { '-l', 'fr-FR', '--json' }, -- on ajoute la langue ici
        stream = 'stdout',
        parser = function(output)
          local decoded = vim.fn.json_decode(output)
          if not decoded or not decoded.diagnostics then return {} end

          local diagnostics = {}
          for _, diag in ipairs(decoded.diagnostics) do
            table.insert(diagnostics, {
              row = diag.range.start.line + 1,
              col = diag.range.start.character + 1,
              end_row = diag.range["end"].line + 1,
              end_col = diag.range["end"].character + 1,
              source = 'harper',
              message = diag.message,
              severity = vim.diagnostic.severity.WARN,
            })
          end
          return diagnostics
        end,
      }

      lint.linters_by_ft = {
        markdown = {'harper'},
        text = {'harper'},
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  }

