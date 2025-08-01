return {"OscarCreator/rsync.nvim",ft={"php","html","css","asp","cs","sh"},build = 'make',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
        require("rsync").setup()
    end,}
