
return {
    "rachartier/tiny-inline-diagnostic.nvim",
    --event = "VeryLazy", -- Or `LspAttach`
    ft={"cpp","c","rs","javascript","ts","vue","css","sh","bash","fish"},
    priority = 1000, -- needs to be loaded in first
    config = function()
        require('tiny-inline-diagnostic').setup()
        vim.diagnostic.config({ virtual_text = false , multilines = {
     enabled = enabled,
     always_show = false,
             use_icons_from_diagnostic =true, 
             preset="powerline"
    }}) -- Only if needed in your configuration, if you already have native LSP diagnostics
    end   
}
