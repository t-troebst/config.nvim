local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
    return
end

-- Load VS Code style snippets (e.g. from friendly-snippets) lazily
require("luasnip/loaders/from_vscode").lazy_load()

luasnip.config.set_config {
    -- Allows reentering old snippets
    history = true,

    -- Update snippets dynamically while typing
    updateevents = "TextChanged,TextChangedI",

    -- Delete snippets from history when appropriate
    delete_check_events = "InsertLeave",

    -- Don't need autosnippets for now
    enabled_autosnippets = false,
}
