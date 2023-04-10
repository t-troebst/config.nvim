local lualine = require("lualine")

local ft_fmt = function(str)
    if str == "" then
        return "none"
    else
        return str
    end
end

local filetype = {
    "filetype",
    icons_enabled = false,
    fmt = ft_fmt,
}

local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = " ", warn = " " },
    colored = false,
    update_in_insert = false,
    always_visible = true,
}

local branch = {
    "branch",
    icons_enabled = true,
    icon = "",
}

-- cool function for progress
local progress = function()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local chars = { "  ", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
    local line_ratio = current_line / total_lines
    local index = math.ceil(line_ratio * #chars)
    return chars[index]
end

lualine.setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "dashboard", "NvimTree", "Outline" },
        always_divide_middle = true,
    },
    sections = {
        lualine_a = {
            { "mode", separator = { left = "" }, right_padding = 2 },
        },
        lualine_b = { diagnostics, branch },
        lualine_c = { "filename" },
        lualine_x = { "filesize" },
        lualine_y = { filetype, progress },
        lualine_z = {
            { "location", separator = { right = "" }, left_padding = 2 },
        },
    },
    inactive_sections = {
        lualine_a = {
            { "mode", separator = { left = "" }, right_padding = 2 },
        },
        lualine_b = { diagnostics, branch },
        lualine_c = { "filename" },
        lualine_x = { "filesize" },
        lualine_y = { filetype, progress },
        lualine_z = {
            { "location", separator = { right = "" }, left_padding = 2 },
        },
    },
    tabline = {},
    extensions = {},
})

-- Activate global status line
vim.opt.laststatus = 3
