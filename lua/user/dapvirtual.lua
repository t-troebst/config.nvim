-- DAP Virtual Text
local status_ok, dap_virtual = pcall(require, "nvim-dap-virtual-text")
if not status_ok then
    return
end

dap_virtual.setup({
    highlight_changed_variables = true,
    highlight_new_as_changed = true,
    enabled_commands = true,
})
