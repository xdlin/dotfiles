vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.loader.enable()
require("config")
require("plugins")
require("lsp")
require("keymaps")
require("diagnostics")
require("autocmds")
-- vim: ts=2 sts=2 sw=2 et
