vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { noremap = true, silent = true, buffer = args.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  end,
})

vim.lsp.enable("ts_ls")

return {
  { "neovim/nvim-lspconfig" },
}
