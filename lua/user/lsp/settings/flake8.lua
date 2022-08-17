return {
    extra_args = function()
        local file = vim.fn.findfile("mypy.ini", ".;")
        if file ~= "" then
            return { "--config-file", file }
        end
    end
}
