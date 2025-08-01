return { 
    "franco-ruggeri/pdf-preview.nvim", 
    opts = {
        -- Override defaults here
    },
    config = function(_, opts)
        require("pdf-preview").setup(opts)

        -- Add your keymaps here
    end
}
