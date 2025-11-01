local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.semanticTokens = { multilineTokenSupport = true }
return capabilities
