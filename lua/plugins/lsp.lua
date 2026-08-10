-- LSP: 语言服务器协议（跨文件跳转、补全、悬停、引用等）
-- 链路：mason.nvim 安装二进制 → mason-lspconfig 自动配置 → lspconfig 注册到 buffer
local function setup_lsp_keys()
  -- 注册键位：gd 跳转定义 / gh 悬停 / gr 引用 / g; 跳回上次位置
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local opts = { noremap = true, silent = true, buffer = args.buf }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "g;", vim.lsp.buf.jump_back, opts)
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
      automatic_enable = true,                     -- 自动启用已安装的 server
    },
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      setup_lsp_keys()
      -- 显式启动 TypeScript 语言服务器（跨文件跳转、引用查找依赖它）
      -- 二进制由 Mason 提供（typescript-language-server），lspconfig 自动发现
      require("lspconfig").ts_ls.setup({})
    end,
  },
}
