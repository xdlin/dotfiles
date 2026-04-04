vim.pack.add({
  "https://github.com/f4z3r/gruvbox-material.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/echasnovski/mini.clue",
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },

  -- dependencies
  "https://github.com/nvim-tree/nvim-web-devicons",
})

require('mini.surround').setup()
require("mini.ai").setup()
require("mini.extra").setup()
require("mini.icons").setup()
require("mini.files").setup({
  windows = { preview = true }
})
require("mini.clue").setup({
  triggers = {
    { mode = "n", keys = "<leader>" },
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
  },

  clues = {
    require("mini.clue").gen_clues.square_brackets(),
  },
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

vim.cmd.colorscheme('gruvbox-material')
require("gitsigns").setup({ signcolumn = false })

require("nvim-treesitter").setup({
  ensure_installed = { "lua", "rust" },
  highlight = { enable = true },
})
-- vim: ts=2 sts=2 sw=2 et
