vim.filetype.add({
    extension = {
        http = "http",
    },
})
vim.filetype.add({
    extension = {
        rs = "rust",
    },
})
vim.filetype.add({
    extension = {
        log = "log",
    },
})
vim.filetype.add({
  extension = {
    sh = "sh",
    bash = "sh",
    zsh = "sh",
    ksh = "sh",
    csh = "sh",
    fish = "sh",
    profile = "sh",
  },
  filename = {
    -- files without extension but common shell names
    [".bashrc"] = "sh",
    [".zshrc"] = "sh",
    [".profile"] = "sh",
    ["bash_profile"] = "sh",
    ["zshenv"] = "sh",
  },
  pattern = {
    -- detect by shebang line for shell scripts (fallback)
    ["^#!.*\\b(bash|sh|zsh|ksh|csh|fish)"] = "sh",
  },
})

