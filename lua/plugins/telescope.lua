local function setup()
    local telescope = require("telescope")

    telescope.load_extension("zf-native")
    telescope.load_extension("project")

    telescope.setup {
        extensions = {
            frecency = {
                workspaces = {
                    cfg = vim.fn.stdpath("config"),
                },
            },

            project = {
                sync_with_nvim_tree = true,
            },
        },
    }
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "natecraddock/telescope-zf-native.nvim",
        "nvim-telescope/telescope-project.nvim",
    },
    config = setup,
    cmd = { "Telescope" }
}
