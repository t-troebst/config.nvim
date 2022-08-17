return {
    extra_args = function()
        local file = vim.fn.findfile("flake8.ini", ".;")
        if file ~= "" then
            return { "--append-config", file }
        end
    end
}
