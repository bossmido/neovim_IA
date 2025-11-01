
local function apply_clangd_fixes()
    if #vim.lsp.get_clients({ name = "clangd" }) == 0 then return end
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.fixAll"}}


  local clients = vim.lsp.get_active_clients({name = "clangd"})
  if #clients == 0 then return end

  vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, result, ctx)
    if err or not result or vim.tbl_isempty(result) then return end
    for _, action in ipairs(result) do
      if action.edit or type(action.command) == "table" then

        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit)
        end
        if type(action.command) == "table" then
          vim.lsp.buf.execute_command(action.command)
        end
      else
        vim.lsp.buf.execute_command(action)
      end
    end
  end)
end
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {"*.cpp", "*.h", "*.hpp"},
  callback = apply_clangd_fixes,
})
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    for _, client in ipairs(clients) do
      if client.name == "clangd" then
        vim.diagnostic.setqflist({ open = false }) -- or open=true to open quickfix window
        break
      end
    end
  end,
})

