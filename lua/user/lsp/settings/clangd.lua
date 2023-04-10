return {
    cmd = {
        "clangd",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
    },
    fallbackFlags = {
        "-std=c++20"
    }
}
