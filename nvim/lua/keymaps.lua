vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = "open quickfix window" })
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = "open float window" })

-- Search
local pick = require("mini.pick")
local extra = require("mini.extra")
vim.keymap.set("n", "<C-p>", pick.builtin.files, { desc = "search files" })
vim.keymap.set("n", "<leader>sb", pick.builtin.buffers, { desc = "search buffers" })
vim.keymap.set("n", "<leader>sf", pick.builtin.files, { desc = "search files" })
vim.keymap.set("n", "<leader>sg", pick.builtin.grep_live, { desc = "grep live" })
vim.keymap.set("n", "<leader>sh", pick.builtin.help, { desc = "search help" })
vim.keymap.set("n", "<leader>si", '<cmd>edit $MYVIMRC<CR>', { desc = "edit vimrc" })

vim.keymap.set("n", "<leader>s.", function()
  extra.pickers.oldfiles()
end, {desc = "recent files"})

vim.keymap.set("n", "<leader>sw", function()
  pick.builtin.grep({ pattern = vim.fn.expand("<cword>") })
end, { desc = "search current word" })

vim.keymap.set('n', "sr", function()
  extra.pickers.lsp({ scope = 'references' })
end)

-- Toggle
vim.keymap.set("n", "<leader>tt", function()
  local mf = require("mini.files")
  if mf.get_explorer_state() then
    mf.close()
  else
    mf.open(vim.api.nvim_buf_get_name(0), true)
  end
end, { desc = "Toggle explorer" })

vim.keymap.set("n", "<leader>ti", '<cmd>vertical term<CR>', { desc = "Terminal (vertical)" })

-- diagnostic keymaps
local diagnostic_goto = function(next, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump({ count = next and 1 or -1, float = true, severity = severity })
  end
end
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
-- vim: ts=2 sts=2 sw=2 et
