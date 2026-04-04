---@type vim.lsp.Config
return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod' },
  root_markers = { 'go.mod', 'go.sum' },
}
-- vim: ts=2 sts=2 sw=2 et
