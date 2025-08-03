
return
{
    "cvigilv/esqueleto.nvim",
    version="*",
    dependencies = {
        "nvim-lua/plenary.nvim", -- Make sure to include this dependency
    },
    config = function()
    end,
    opts={
        templates = {
            {
                pattern = "%.py$",
                filename = "python.py",
            },
            {
                pattern = "%.lua$",
                filename = "nvim_config.lua",
            },
            {
                pattern = "%.sh$",
                filename = "script.sh",
            },
            {
                pattern = "Makefile$",
                filename = "Makefile",
            },

        },
        templates_dir = '~/.config/nvim/templates', -- Directory where your templates are stored
    }
}
