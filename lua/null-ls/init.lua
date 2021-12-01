local c = require("null-ls.config")
local helpers = require("null-ls.helpers")
local log = require("null-ls.logger")
local sources = require("null-ls.sources")

local M = {}

M.deregister = sources.deregister
M.disable = sources.disable
M.enable = sources.enable
M.get_source = sources.get
M.get_sources = sources.get_all
M.is_registered = sources.is_registered
M.register = sources.register
M.register_name = sources.register_name
M.reset_sources = sources.reset
M.toggle = sources.toggle

M.builtins = require("null-ls.builtins")
M.methods = require("null-ls.methods").internal
M.null_ls_info = require("null-ls.info").show_window

M.formatter = helpers.formatter_factory
M.generator = helpers.generator_factory

M.setup = function(user_config)
    if vim.g.null_ls_disable or c.get()._setup then
        return
    end

    c.setup(user_config or {})
    require("null-ls.rpc").setup()

    vim.cmd("command! NullLsInfo lua require('null-ls').null_ls_info()")
    vim.cmd("command! NullLsLog lua vim.fn.execute('edit ' .. require('null-ls.logger').get_path())")

    vim.cmd([[
      augroup NullLs
        autocmd!
        autocmd FileType * lua require("null-ls.client").try_add()
        autocmd InsertLeave * unsilent lua require("null-ls.rpc").flush()
      augroup end
    ]])
end

M.config = function(user_config)
    log:warn("config is deprecated; use setup instead")

    M.setup(user_config)
end

return M
