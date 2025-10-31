
return {
    "Zeioth/compiler.nvim",
    --    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo", "CompilerDebug" },

lazy=false,

    opts = {

        default_task_opts = {
            strategy = "background",
            cwd = vim.fn.getcwd(),

        },

        notify_on_complete = true,


        save_on_compile = true,
        jump_to_error = true,

    },

}



