return {
    "huggingface/llm.nvim",
    event = "CmdlineEnter",
    config = function()
        require("llm").setup({
            backend = "anthropic", -- or "openai", "huggingface", etc.
            model = "claude-3-haiku-20240307",
            api_key = os.getenv("ANTHROPIC_API_KEY"),
        })
        -- Optional keymaps for easy usage
        vim.keymap.set("n", "<leader>lc", ":LLM Chat<CR>", { desc = "Start Ollama Chat" })
        vim.keymap.set("n", "<leader>ll", ":LLM Complete<CR>", { desc = "Ollama Complete" })
    end,
}
