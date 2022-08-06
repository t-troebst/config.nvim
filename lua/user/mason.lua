local mason_ok, mason = pcall(require, "mason")
if not mason_ok then return end

mason.setup()
