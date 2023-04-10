local dap = require("dap")

vim.fn.sign_define(
    "DapBreakpoint",
    { text = "🅱", texthl = "Breakpoint", linehl = "", numhl = "Breakpoint" }
)
vim.fn.sign_define(
    "DapBreakpointCondition",
    { text = "🅲", texthl = "Breakpoint", linehl = "", numhl = "Breakpoint" }
)
vim.fn.sign_define("DapStopped", { text = "", texthl = "Continue", linehl = "", numhl = "" })
vim.fn.sign_define(
    "DapLogPoint",
    { text = "🅻", texthl = "Logpoint", linehl = "", numhl = "Logpoint" }
)
vim.fn.sign_define(
    "DapBreakpointRejected",
    { text = "✗", texthl = "Continue", linehl = "", numhl = "Breakpoint" }
)

local function conditional_breakpoint()
    vim.ui.input({ prompt = "Condition: " }, function(value)
        dap.set_breakpoint(value)
    end)
end

local function logpoint()
    vim.ui.input({ prompt = "Log: " }, function(log)
        dap.set_breakpoint(nil, nil, log .. "\n")
    end)
end

local function conditional_logpoint()
    vim.ui.input({ prompt = "Log: " }, function(log)
        vim.ui.input({ prompt = "Condition: " }, function(condition)
            dap.set_breakpoint(condition, nil, log .. "\n")
        end)
    end)
end

vim.api.nvim_create_user_command("DapConditionalBreakpoint", conditional_breakpoint, {})
vim.api.nvim_create_user_command("DapLogpoint", logpoint, {})
vim.api.nvim_create_user_command("DapConditionalLogpoint", conditional_logpoint, {})

local function dap_config()
    local config_file = vim.fs.find(".dap.json", { upward = true, type = "file" })[1]
    if not config_file then
        return {}
    end

    local config_json = ""
    local config_handle = io.open(config_file)
    if config_handle then
        config_json = config_handle:read("a")
        config_handle:close()
    else
        return {}
    end

    local ok, config = pcall(vim.json.decode, config_json)
    if not ok then
        vim.notify("Could not decode .dap.json", vim.log.levels.ERROR)
        return {}
    end

    if not config.cwd then
        config.cwd = vim.fs.dirname(config_file)
    end

    return config
end

local function select_target(config)
    if not config.targets then
        return nil
    else
        local coro = coroutine.running()

        vim.schedule(function()
            vim.ui.select(config.targets, {
                prompt = "Choose target:",
                format_item = function(target)
                    return target.name or (target.program .. " " .. table.concat(target.args, " "))
                end,
            }, function(target)
                coroutine.resume(coro, target)
            end)
        end)

        return coroutine.yield()
    end
end

-- C++/C/Rust

dap.adapters.lldb = {
    type = "executable",
    command = "/usr/bin/lldb-vscode",
    name = "lldb",
}

local cpp_config = {
    name = "Launch",
    type = "lldb",
    request = "launch",
    stopOnEntry = false,
    runInTerminal = false,
}

setmetatable(cpp_config, {
    __call = function(conf)
        local config = dap_config()
        local target = select_target(config)

        local new_conf = vim.deepcopy(conf)
        new_conf.cwd = config.cwd or "${workspaceFolder}"

        if not target then
            local coro = coroutine.running()
            vim.schedule(function()
                vim.ui.input({
                    prompt = "Path to executable:",
                    completion = "file",
                    default = vim.fn.getcwd() .. "/",
                }, function(path)
                    coroutine.resume(coro, path)
                end)
            end)
            new_conf.program = coroutine.yield()
            new_conf.args = {}
        else
            new_conf.program = target.program
            new_conf.args = target.args or {}
        end

        return new_conf
    end,
})

dap.configurations.cpp = {
    cpp_config,
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- Python

dap.adapters.python = {
    type = "executable",
    command = "python",
    args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
            -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
            -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
            -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                return cwd .. "/venv/bin/python"
            elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                return cwd .. "/.venv/bin/python"
            else
                return "/usr/bin/python"
            end
        end,
    },
}
