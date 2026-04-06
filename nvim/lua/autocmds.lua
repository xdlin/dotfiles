vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "rust", "lua" },
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- vim: ts=2 sts=2 sw=2 et
