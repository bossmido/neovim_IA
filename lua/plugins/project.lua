return {
    'ahmedkhalf/project.nvim',
    event = "CmdlineEnter",
    config = function()
        require("project_nvim").setup {}
        require("telescope").load_extension("projects")
    end
}
