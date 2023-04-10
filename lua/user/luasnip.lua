local luasnip = require("luasnip")

luasnip.setup {
    -- Allows reentering old snippets
    history = true,

    -- Update snippets dynamically while typing
    update_events = {"TextChanged", "TextChangedI"},

    -- Delete snippets from history when appropriate
    delete_check_events = "InsertLeave",

    -- Don't need autosnippets for now
    enabled_autosnippets = false,

    -- Ask treesitter for filetype for sub-languages
    ft_func = require("luasnip.extras.filetype_functions").from_pos_or_filetype
}

-- Set up actual snippets, TODO: lazy loading

require("luasnip.loaders.from_lua").load {paths = "./lua/user/snippets"}
