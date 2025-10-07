return {
    "Owen-Dechow/nvim_json_graph_view",
    -- Load only when needed (commands, filetype, or user action)
    cmd = { "JsonGraphView", "GraphViewOpen", "GraphViewToggle" }, -- adjust to actual plugin commands
    ft = { "json", "yaml", "yml" }, -- load only for relevant files
    dependencies = {
        {
            "Owen-Dechow/graph_view_yaml_parser",
            optional = true, -- makes it non-blocking if missing
        },

    },
    opts = {
        round_units = false,
    },
}
