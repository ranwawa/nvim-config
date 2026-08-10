-- LSP: 语言服务器协议（跨文件跳转、补全、悬停、引用等）
-- 通过 lspconfig 真正启动语言服务器，配合 Mason 管理二进制
local lspconfig = require("lspconfig")

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      -- 注册键位：gd 跳转定义 / gh 悬停 / gr 引用 / g; 跳回
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { noremap = true, silent = true, buffer = args.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "g;", vim.lsp.buf.jump_back, opts)
        end,
      })

      -- 由 mason-lspconfig 在 Mason 装好后自动执行每个 server 的 setup
      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls" }, -- 确保 TypeScript 语言服务器已安装
        automatic_enable = true,        -- 自动启用已安装的 server
      })
    end,
  },
}
