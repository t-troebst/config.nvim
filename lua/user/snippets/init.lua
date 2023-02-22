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

--- Reloads snippets for a given language, useful for editing snippets without restarting.
-- @param lang Language / filetype name.
-- @return Module containing the snippets.
local function reload_snips(lang)
    package.loaded["user.snippets." .. lang] = nil
    return require("user.snippets." .. lang)
end

ls.add_snippets(nil, {
    all = reload_snips("all"),
    cpp = reload_snips("cpp"),
    tex = reload_snips("tex"),
    lua = reload_snips("lua"),
    markdown = reload_snips("markdown"),
    python = reload_snips("python")
})

