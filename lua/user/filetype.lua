-- Autocommands for filetypes

local function get_clang_format()
    local clang_format_file = vim.fn.findfile(".clang-format", ".;")

    if clang_format_file == "" then
        return {}
    end

    -- clang-format uses the horrific format that is YAML, so this is merely a hack...
    local result = {}
    for line in io.lines(clang_format_file) do
        local key, value = line:match("%s*(.-):%s*(.*)$")

        if key then
            result[key] = value
        end
    end

    return result
end

local function is_chromium()
    if vim.fn.expand("%:p"):match("/chromium/") then
        return true
    else
        return false
    end
end

vim.api.nvim_create_autocmd(
    "FileType",
    {
        pattern = { "cpp" },
        callback = function()
            local clang_format = get_clang_format()
            local tw = tonumber(clang_format.ColumnLimit)
            local sw = tonumber(clang_format.IndentWidth)

            if is_chromium() then
                tw = 80
                sw = 2
            end

            if tw then
                vim.opt_local.textwidth = tw
                vim.opt_local.colorcolumn = { tw + 1 }
            end
            if sw then
                vim.opt_local.shiftwidth = sw
                vim.opt_local.tabstop = sw
            end
        end
    }
)
