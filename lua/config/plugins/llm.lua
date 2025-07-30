return {
  "huggingface/llm.nvim",
  event = "VeryLazy",
  config = function()
    require("llm").setup({
      backend = "anthropic", -- or "openai", "huggingface", etc.
      model = "claude-3-haiku-20240307",
      api_key = os.getenv("ANTHROPIC_API_KEY"),
    })
  end,
}
