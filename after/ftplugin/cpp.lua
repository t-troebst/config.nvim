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

-- Create semantic highlight to show non-const variables
-- This is kind of hack, wish clangd supported this better :/

local ts_utils_ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
if not ts_utils_ok then
    return {}
end

local cpp_const_methods = vim.treesitter.query.parse("cpp", [[
    (function_definition
        declarator: (function_declarator (type_qualifier "const"))
        body: (compound_statement) @body
    )
]])


local const_methods = ts_utils.memoize_by_buf_tick(function(start_col, line)
    local root = ts_utils.get_root_for_position(line - 1, start_col - 1)
    local result = {}

    for _, captures, _ in cpp_const_methods:iter_matches(root) do
        table.insert(result, { ts_utils.get_vim_range({ captures[1]:range() }) })
    end

    return result
end, {
    bufnr = 0,
    key = function(start_col, line)
        local root = ts_utils.get_root_for_position(line - 1, start_col - 1)
        return root:range()
    end
})

local function is_in_const_method(start_col, line)
    local ranges = const_methods(start_col, line)

    for _, range in ipairs(ranges) do
        if (range[1] == line and range[2] <= start_col)
            or (range[3] == line and start_col <= range[4])
            or (range[1] < line and line < range[3]) then
            return true
        end
    end

    return false
end

local augroup = vim.api.nvim_create_augroup("CppSemanticHighlights", { clear = false })
vim.api.nvim_clear_autocmds({ buffer = 0, group = augroup })
vim.api.nvim_create_autocmd("LspTokenUpdate", {
    buffer = 0,
    group = augroup,
    callback = function(args)
        local token = args.data.token

        if token.type == "variable" and not token.modifiers.readonly then
            vim.lsp.semantic_tokens.highlight_token(token, args.buf, args.data.client_id, "mutable")
        end

        if token.type == "property" and not token.modifiers.readonly  and not token.modifiers.declaration then
            if not is_in_const_method(args.data.token.start_col, args.data.token.line) then
                vim.lsp.semantic_tokens.highlight_token(token, args.buf, args.data.client_id, "mutable")
            end
        end
    end
})
