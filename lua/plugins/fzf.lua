return {
    'junegunn/fzf.vim',       -- fzf.vim plugin
    cmd = { 'Files', 'Buffers', 'GFiles', 'Rg' },  -- load on these commands
    -- keys = {
        --   { '<leader>f', ':Files<CR>', desc = 'FZF Files' },}
        --   {
            dependencies = {
                {
                    "junegunn/fzf",

                    build = ":call fzf#install()",

                }
            }

        }
