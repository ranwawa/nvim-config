-- LSP: 语言服务器协议（跨文件跳转、补全、悬停、引用等）
-- 链路：mason.nvim 安装二进制 → mason-lspconfig 自动启用 → vim.lsp 注册到 buffer
--
-- 注：Neovim 0.11+ 使用内置的 vim.lsp.config / vim.lsp.enable 新框架，
-- 不再使用已弃用的 require("lspconfig").xxx.setup() 旧框架调用（会在 3.0 移除）。
local function setup_lsp_keys()
  -- 注册键位：gd 跳转定义 / gh 悬停 / gr 引用 / g; 跳回上次位置
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local opts = { noremap = true, silent = true, buffer = args.buf }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "g;", "<C-o>", opts)            -- 跳回上次位置（Vim 原生）
    end,
  })
end

return {
  {
    "williamboman/mason.nvim",
    lazy = false,                                  -- 启动即加载
    opts = {},                                     -- 触发 mason.setup()
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      { "williamboman/mason.nvim" },               -- 保证 mason 先 setup
      { "neovim/nvim-lspconfig" },
    },
    opts = {
      ensure_installed = { "ts_ls" },              -- 缺失时自动安装 ts_ls
      automatic_enable = true,                     -- 自动启用已安装的 server（内部走 vim.lsp.enable）
    },
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      setup_lsp_keys()
      -- 显式启用 TypeScript 语言服务器（新 API，配合上面 automatic_enable 双保险）
      vim.lsp.enable("ts_ls")
    end,
  },
}
