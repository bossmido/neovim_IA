return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    default = {
              notify = false, -- <─ disables that yellow “Content is not an image” window
      dir_path = "images",      -- folder for pasted images
      prompt_for_file_name = true,
      insert_mode = true,
      file_name = function()
        return os.date("%Y-%m-%d_%H-%M-%S")
      end,
      use_absolute_path = false,  -- relative paths in Markdown
      filetype_config = {
        markdown = {
          template = "![$FILE_NAME]($FILE_PATH)"
        },
        tex = {
          template = "\\includegraphics{$FILE_PATH_NOEXT}"
        },
      },
    },
  },
  keys = {
    { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
  },
}
