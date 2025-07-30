function M.telescope_find()
  require("telescope.builtin").lsp_document_symbols {
    symbols = {
      "Class",
      "Function",
      "Method",
      "Constructor",
      "Interface",
      "Module",
      "Struct",
      "Trait",
      "Field",
      "Property",
    },
  }
end
