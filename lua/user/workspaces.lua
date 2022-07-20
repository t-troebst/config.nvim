local workspaces_ok, workspaces = pcall(require, "workspaces")
if not workspaces_ok then return end

workspaces.setup()
