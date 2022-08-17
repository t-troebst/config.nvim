return {
    extra_args = function()
        local file = vim.fn.findfile("mypy.ini", ".;")
        local full_path = vim.fn.fnamemodify(file, ":p")
        if file ~= "" then
            return { "--config-file", full_path }
        end
    end
}
