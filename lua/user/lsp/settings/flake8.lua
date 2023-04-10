return {
    extra_args = function()
        local file = vim.fn.findfile("flake8.ini", ".;")
        local full_path = vim.fn.fnamemodify(file, ":p")
        if file ~= "" then
            return { "--append-config", full_path }
        end
    end,
}
