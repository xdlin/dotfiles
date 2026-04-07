vim.pack.add({
  "https://github.com/f4z3r/gruvbox-material.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },

  -- dependencies
  "https://github.com/nvim-tree/nvim-web-devicons",
})

require("mini.extra").setup()
require("mini.icons").setup()
require("mini.files").setup({
  windows = { preview = true }
})
require("mini.pick").setup({
  window = {
    config = function()
      local height = math.floor(vim.o.lines * 0.6)
      local width = math.floor(vim.o.columns * 0.6)

      return {
        relative = "editor",
        anchor = "NW",
        height = height,
        width = width,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        border = "rounded",
      }
    end,
  },
})

require("lualine").setup({
  options = {
    theme = "gruvbox-material",
    -- section_separators = { left = "", right = "" },
    section_separators = { left = '', right = '' },
    component_separators = "",
  },
  sections = {
    lualine_x = {
      'lsp_status', 'encoding', 'fileformat', 'filetype'
    },
  },
})

vim.cmd.colorscheme('gruvbox-material')

require("nvim-treesitter").setup({
  ensure_installed = { "lua", "rust", "go" },
  highlight = { enable = true },
})

local misc = require('mini.misc')
local later = function(f) misc.safely('later', f) end
local on_event = function(ev, f) misc.safely('event:' .. ev, f) end

later(function()
  require('mini.cmdline').setup()
  require('mini.surround').setup()
  require("mini.ai").setup()
end)

on_event('BufReadPre', function()
  require("gitsigns").setup({ signcolumn = false })
end)

on_event('InsertEnter', function()
  require('blink.cmp').setup({
    keymap = {
      preset = "default",
      ['<CR>'] = { 'accept', 'fallback' },
    },
    appearance = { nerd_font_variant = "mono" },
    completion = {
      documentation = { auto_show = false },
    },
    signature = { enabled = true },
    sources = { default = { "lsp", "path", "snippets", "buffer" }, },
  })
end)
-- vim: ts=2 sts=2 sw=2 et
