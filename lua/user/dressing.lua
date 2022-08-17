local status_ok, dressing = pcall(require, "dressing")
if not status_ok then
    return
end

dressing.setup({
    -- Doesn't work too well for me...
    input = { enabled = false },
})
