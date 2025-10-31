vim.g.lazyvim_blink_main = true
require("config.lazy")
require("config.keymap")
require("config.autocmd")
require("config.filetype")
--ME MIENS
require("config.cpp")


require('lspconfig').rust_anaiddodocdlyzer.setup{}
