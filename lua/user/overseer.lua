local overseer = require("overseer")

overseer.setup()

local function get_cmake_lists(opts)
    return vim.fs.find("CMakeLists.txt", { upward = true, type = "file", path = opts.dir })[1]
end

local function get_cmake_presets(file)
    local presets_json = ""
    local presets_handle = io.open(file)
    if presets_handle then
        presets_json = presets_handle:read("a")
        presets_handle:close()
    else
        return {}
    end

    local ok, presets = pcall(vim.json.decode, presets_json)
    if not ok then
        return {}
    end
    return presets["configurePresets"] or {}
end

local function get_cmake_builds(cwd)
    local cache_files = vim.fs.find("CMakeCache.txt", { type = "file", limit = 10, path = cwd })
    local build_dirs = {}
    for _, cache_file in ipairs(cache_files) do
        table.insert(build_dirs, vim.fs.dirname(cache_file))
    end
    return build_dirs
end

local function cmake_boolean(b)
    if b then
        return "ON"
    else
        return "OFF"
    end
end

local function cmake_setup_task(cwd)
    return {
        name = "CMake Setup",
        builder = function(params)
            return {
                cmd = { "cmake" },
                args = { "-DCMAKE_BUILD_TYPE=" .. params.build_type, "-B", params.dir,
                    "-DCMAKE_EXPORT_COMPILE_COMMANDS=" .. cmake_boolean(params.compile_commands) },
                cwd = cwd
            }
        end,
        tags = { overseer.TAG.BUILD },
        params = {
            build_type = {
                name = "Build Type",
                type = "enum",
                default = "Debug",
                choices = { "Debug", "Release", "RelWithDebInfo", "MinSizeRel" }
            },
            dir = {
                name = "Build Directory",
                default = "build"
            },
            compile_commands = {
                name = "Export Compile Commands",
                type = "boolean",
                default = true
            }
        },
        priority = 42
    }
end

local function cmake_preset_tasks(cwd)
    local presets = get_cmake_presets(cwd .. "/CMakePresets.json")
    vim.list_extend(presets, get_cmake_presets(cwd .. "/CMakeUserPresets.json"))
    local preset_tasks = {}

    for _, preset in ipairs(presets) do
        table.insert(preset_tasks, {
            name = "CMake Preset (" .. preset.name .. ")",
            builder = function()
                return {
                    cmd = {"cmake"},
                    args = {"--preset", preset.name},
                    cwd = cwd
                }
            end,
            tags = { overseer.TAG.BUILD },
            priority = 41
        })
    end

    return preset_tasks
end

local function cmake_build_tasks(cwd)
    local build_tasks = {}

    for _, build_dir in ipairs(get_cmake_builds(cwd)) do
        table.insert(build_tasks, {
            name = "CMake Build (" .. vim.fs.basename(build_dir) .. ")",
            builder = function()
                return {
                    cmd = {"cmake"},
                    args = {"--build", build_dir},
                    cwd = cwd
                }
            end,
            tags = { overseer.TAG.BUILD },
            priority = 40
        })
    end

    return build_tasks
end

overseer.register_template {
    name = "CMake Setup",

    generator = function(opts, cb)
        local cmake_lists = get_cmake_lists(opts)
        local cwd = vim.fs.dirname(cmake_lists)

        local tasks = {cmake_setup_task(cwd)}
        vim.list_extend(tasks, cmake_preset_tasks(cwd))
        vim.list_extend(tasks, cmake_build_tasks(cwd))
        cb(tasks)
    end,

    condition = {
        callback = function(opts)
            if vim.fn.executable("cmake") == 0 then
                return false, 'Command "cmake" not found'
            end
            if not get_cmake_lists(opts) then
                return false, "No CMakeLists.txt found"
            end
            return true
        end
    }
}

overseer.register_template {
    name = "LaTeX Build",

    generator = function(opts, cb)
        local templates = {}

        for name, type in vim.fs.dir(opts.dir) do
            if type == "file" and name:match(".*%.tex") then
                local priority = 40
                if name == "ms.tex" or name == "main.tex" then
                    priority = 35
                end

                table.insert(templates, {
                    name = "Latex Build (" .. vim.fs.basename(name) .. ")",
                    builder = function()
                        return {
                            cmd = {"latexmk"},
                            args = {"-pdf", name},
                            cwd = opts.dir
                        }
                    end,
                    tags = { overseer.TAG.BUILD },
                    priority = priority
                })
            end
        end

        cb(templates)
    end,
}
