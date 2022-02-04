local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local colors = {
    blue   = "#569CD6",
    green  = "#6A9955",
    rust   = "#CE9178",
    violet = "#C586C0",
    bg     = "#252525",
    dark   = "#101010",
    grey   = "#303030",
}

local bubbles_theme = {
    normal = {
        a = { fg = colors.black, bg = colors.blue, gui = "bold" },
        b = { fg = colors.white, bg = colors.grey },
        c = { fg = colors.black, bg = colors.bg },
    },

    insert = { a = { fg = colors.black, bg = colors.rust, gui = "bold" } },
    visual = { a = { fg = colors.black, bg = colors.green, gui = "bold" } },
    replace = { a = { fg = colors.black, bg = colors.violet, gui = "bold" } },

    inactive = {
        a = { fg = colors.black, bg = colors.bg, gui = "bold" },
        b = { fg = colors.white, bg = colors.grey },
        c = { fg = colors.black, bg = colors.dark },
    },
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
	local chars = {  "  ", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
	local line_ratio = current_line / total_lines
	local index = math.ceil(line_ratio * #chars)
	return chars[index]
end

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "dashboard", "NvimTree", "Outline" },
		always_divide_middle = true,
	},
	sections = {
        lualine_a = {
            { 'mode', separator = { left = '' }, right_padding = 2 },
        },
        lualine_b = { diagnostics, branch },
        lualine_c = {  },
        lualine_x = {},
        lualine_y = { 'filename', progress },
        lualine_z = {
            { "location", separator = { right = '' }, left_padding = 2 },
        },
	},
	inactive_sections = {
        lualine_a = {
            { 'mode', separator = { left = '' }, right_padding = 2 },
        },
        lualine_b = { diagnostics, branch },
        lualine_c = {  },
        lualine_x = {},
        lualine_y = { 'filename', progress },
        lualine_z = {
            { "location", separator = { right = '' }, left_padding = 2 },
        },
	},
	tabline = {},
	extensions = {},
})
