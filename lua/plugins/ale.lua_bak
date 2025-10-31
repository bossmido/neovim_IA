return {
  "dense-analysis/ale",
  event = "BufReadPre",
  config = function()
    vim.g.ale_fix_on_save = 1
    vim.g.ale_linters = {
      cpp = { "clang" },
      c = { "clang" },
    }
    vim.g.ale_fixers = {
      cpp = { "clang-format" },
      c = { "clang-format" },
    }
    vim.g.ale_cpp_clang_executable = "clang"
    vim.g.ale_c_clang_executable = "clang"
  end,
}
