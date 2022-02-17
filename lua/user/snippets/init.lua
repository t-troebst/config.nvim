local snip_status_ok, ls = pcall(require, "luasnip")
if not snip_status_ok then
    return
end

ls.config.set_config {
    -- Allows reentering old snippets
    history = true,

    -- Update snippets dynamically while typing
    updateevents = "TextChanged,TextChangedI",

    -- Delete snippets from history when appropriate
    delete_check_events = "InsertLeave",

    -- Don't need autosnippets for now
    enabled_autosnippets = false,

    -- Ask treesitter for filetype for sub-languages
    ft_func = require("luasnip.extras.filetype_functions").from_pos_or_filetype
}

-- Set up actual snippets, TODO: lazy loading

ls.snippets = {
    all = require("user.snippets.all"),
    cpp = require("user.snippets.cpp"),
    latex = require("user.snippets.tex"),
    lua = require("user.snippets.lua"),
    markdown = require("user.snippets.markdown"),
    python = require("user.snippets.python")
}

