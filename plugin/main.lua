local null_ls = require("null-ls")
local methods = require("null-ls.methods")
local ts_utils = require("nvim-treesitter.ts_utils")


local function read_file(filename)
    local uv = vim.loop
    local fd = uv.fs_open(filename, 'r', 438)
    if not fd then
        return ''
    end
    local stat = uv.fs_fstat(fd)
    local data = uv.fs_read(fd, stat.size, 0)
    uv.fs_close(fd)
    return data
end

local function node_at_tw_node()
    local node = ts_utils.get_node_at_cursor()
    if not node then
        return false
    end
    local parent = node:parent()
    if not parent then
        return false
    end
    local ident = parent:named_child()
    local ident_name = vim.treesitter.get_node_text(ident, 0)

    return node:type() == "template_string" and ident_name == "tw"
end

-- needs to be called as soon as the plugin is sourced
-- so it can't be inside a callable function
local classes_path = vim.fn.expand('<sfile>:p:h') .. "/classes.json"

local function register_tailwind()
    local classes = vim.fn.json_decode(read_file(classes_path))
    local classes_items = {}
    for i, class in ipairs(classes) do
        classes_items[i] = {
            label = class.id,
            documentation = class.type,
        }
    end

    local tw = {
        name = "tw",
        method = methods.internal.COMPLETION,
        filetypes = {},
        generator = {
            fn = function(_, done)
                local items = {}
                if node_at_tw_node() then
                    items = classes_items
                end
                return done({
                    {
                        items = items,
                        isIncomplete = true,
                    }
                })
            end,
            async = true
        },
    }

    null_ls.register(tw)
end

vim.api.nvim_create_user_command("RegisterTw", register_tailwind, {})
vim.api.nvim_create_user_command("DeregisterTw", function()
    null_ls.deregister("tw")
end, {})
