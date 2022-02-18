local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

telescope.load_extension("zf-native")
telescope.load_extension("file_browser")
