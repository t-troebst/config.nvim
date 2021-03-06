-- DAP
local status_ok, dap = pcall(require, "dap")
if not status_ok then
    return
end

vim.fn.sign_define("DapBreakpoint", {text='', texthl='Breakpoint', linehl='', numhl='Breakpoint'})
vim.fn.sign_define("DapStopped", {text='', texthl='Continue', linehl='', numhl=''})

local lldb_executable = function()
    local args = vim.fn.findfile(".debug_args.lua", ".;")
    if args == "" then
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    else
        return dofile(args).program
    end
end

local lldb_args = function()
    local args = vim.fn.findfile(".debug_args.lua", ".;")
    if args == "" then
        -- We could ask the user for args but for now lets assume there are none
        return {}
    else
        return dofile(args).args
    end
end

-- C++/C/Rust

dap.adapters.lldb = {
    type = "executable",
    command = "/usr/bin/lldb-vscode",
    name = "lldb",
}

dap.configurations.cpp = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = lldb_executable,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = lldb_args,
        runInTerminal = false,
    },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- Python

dap.adapters.python = {
    type = 'executable';
    command = 'python';
    args = { '-m', 'debugpy.adapter' };
}

dap.configurations.python = {
    {
    type = 'python';
    request = 'launch';
    name = "Launch file";

    program = "${file}";
    pythonPath = function()
        -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
        -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
        -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
        local cwd = vim.fn.getcwd()
        if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
            return cwd .. '/venv/bin/python'
        elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
            return cwd .. '/.venv/bin/python'
        else
            return '/usr/bin/python'
        end
    end;
    },
}
