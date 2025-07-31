return {
    "jackMort/ChatGPT.nvim",
    event = "CmdlineEnter",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        require("chatgpt").setup({
            -- optional: set OpenAI API key directly
            api_key_cmd = "echo $OPENAI_API_KEY",
        })
    end,
}
