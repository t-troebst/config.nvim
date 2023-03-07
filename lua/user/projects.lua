-- Simple project module / code runner

local M = {}

function M.get_project()
    local project_file = vim.fn.findfile(".project.lua", ".;")
    if project_file == "" then
        return nil
    else
        local targets = dofile(project_file)
        return { targets = targets, location = project_file }
    end
end

local function targets(project)
    local ts = {}
    for key, _ in pairs(project.targets) do
        table.insert(ts, key)
    end
    return ts
end

local function ensure_project(continuation)
    local project = M.get_project()
    -- TODO: ask user to create project?
    if project then
        continuation(project)
    else
        error("No project found! Create one with :ProjectConfig!")
    end
end

local selected_targets = {}

function M.get_target()
    local project = M.get_project()
    if not project then return nil end
    local target = selected_targets[project.location] or targets(project)[1]
    return project.targets[target]
end

local function ensure_target(project, continuation)
    local target = selected_targets[project.location] or targets(project)[1]
    continuation(project.targets[target])
end

local function run_command(cmd, args, detach, exit_on_success, on_success, on_failure)
    if detach then
        vim.fn.jobstart(cmd, { detach = true })
        return
    end

    vim.api.nvim_command("botright split new")
    vim.api.nvim_win_set_height(0, 30)
    local buf_handle = vim.api.nvim_win_get_buf(0)
    vim.api.nvim_buf_set_option(buf_handle, "modifiable", true)
    local function on_exit(_, exit_code)
        if exit_code == 0 then
            if exit_on_success then
                vim.api.nvim_buf_delete(buf_handle, {})
            end
            if on_success then on_success() end
        else
            if on_failure then on_failure() end
        end
    end
    vim.fn.termopen(cmd, { on_exit = on_exit })
end

function M.build()
    ensure_project(function(project)
        ensure_target(project, function(target)
            run_command(target.build, nil, true)
        end)
    end)
end

function M.run()
    ensure_project(function(project)
        ensure_target(project, function(target)
            if target.build then
                run_command(target.build, nil, false, true, function()
                    if target.run then
                        run_command(target.run, target.args, target.detach, false)
                    end
                end)
            elseif target.run then
                run_command(target.run, target.args, target.detach, false)
            end
        end)
    end)
end

function M.select_target()
    ensure_project(function(project)
        vim.ui.select(targets(project), { prompt = "Select target: " }, function(target)
            if not target then return end
            selected_targets[project.location] = target
        end)
    end)
end

function M.edit_config()
    local project = M.get_project()

    if project then
        vim.cmd.e(project.location)
    else
        vim.ui.input(
            { prompt = "Project root for directory: ", default = vim.fn.getcwd(), completion = "file" },
            function(dir)
                if dir then
                    vim.cmd.e(dir .. "/.project.lua")
                end
            end)
    end
end

vim.api.nvim_create_user_command("ProjectBuild", M.build, {})
vim.api.nvim_create_user_command("ProjectRun", M.run, {})
vim.api.nvim_create_user_command("ProjectTarget", M.select_target, {})
vim.api.nvim_create_user_command("ProjectConfig", M.edit_config, {})

return M
