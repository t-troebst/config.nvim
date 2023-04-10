local nvim_dap_virtual_text = require("nvim-dap-virtual-text")

nvim_dap_virtual_text.setup {
    highlight_changed_variables = true,
    highlight_new_as_changed = true,
    enabled_commands = true,
}
