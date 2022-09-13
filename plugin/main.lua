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

-- <el class="here"/>
local function node_at_class_node()
    local node = ts_utils.get_node_at_cursor()
    if not node then
        return false
    end
    local gparent = node:parent():parent()
    if not gparent then
        return false
    end
    local prop_ident = gparent:child()
    local ident_name = vim.treesitter.get_node_text(prop_ident, 0)

    return ident_name == "class"
end

-- <el class={tw`here`}/>
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
local classes_path = vim.fn.expand('<sfile>:p:h') .. "/classes"

local function register_tailwind()
    local classes = vim.split(read_file(classes_path), "\n")
    local classes_items = {}
    for i, class in ipairs(classes) do
        classes_items[i] = {
            label = class
        }
    end

    local tw = {
        name = "tw",
        method = methods.internal.COMPLETION,
        filetypes = {},
        generator = {
            fn = function(params, done)
                local items = {}
                if node_at_tw_node() or node_at_class_node() then
                    items = classes_items
                end
                return done({
                    {
                        items = vim.tbl_filter(function(item)
                            return vim.startswith(item.label, params.word_to_complete)
                        end, items),
                        isIncomplete = #items == 0,
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
