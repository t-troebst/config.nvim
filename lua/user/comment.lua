local status_ok, comment = pcall(require, "Comment")
if not status_ok then
    return
end

comment.setup {
    pre_hook = function(ctx)
        local U = require "Comment.utils"

        local location = nil
        if ctx.ctype == U.ctype.block then
            location = require("ts_context_commentstring.utils").get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require("ts_context_commentstring.utils").get_visual_start_location()
        end

        return require("ts_context_commentstring.internal").calculate_commentstring {
            -- key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
            location = location,
        }
    end,
    toggler = {
        line = "<LEADER>cc",
        block = "<LEADER>cb",
    }
}

vim.api.nvim_set_keymap("v", "<LEADER>cc", "<ESC><CMD>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<LEADER>cb", "<ESC><CMD>lua require('Comment.api').toggle_blockwise_op(vim.fn.visualmode())<CR>", {noremap = true, silent = true})
