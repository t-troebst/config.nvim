-- Try to get shiftwidth & tabwidth from clang format

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
    return vim.fn.expand("%:p"):match("/chromium/")
end

local function set_sw_tw(sw, tw)
    if tw then
        vim.opt_local.textwidth = tw
        vim.opt_local.colorcolumn = { tw + 1 }
    end
    if sw then
        vim.opt_local.shiftwidth = sw
        vim.opt_local.tabstop = sw
    end
end

if is_chromium() then
    set_sw_tw(2, 80)
else
    local clang_format = get_clang_format()
    local sw = tonumber(clang_format.IndentWidth)
    local tw = tonumber(clang_format.ColumnLimit)
    set_sw_tw(sw, tw)
end
