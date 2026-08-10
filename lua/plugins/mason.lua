-- Mason: 语言服务器/格式化器/LSP 工具的管理器
-- 通过 :MasonInstall <name> 一键安装，二进制统一放在 ~/.local/share/nvim/mason
return {
  -- Mason 本体
  { "williamboman/mason.nvim" },

  -- 让 lazy 与 Mason、lspconfig 联动的适配层
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      { "williamboman/mason.nvim" },
      { "neovim/nvim-lspconfig" },
    },
    opts = {
      ensure_installed = { "ts_ls" }, -- 启动时确保已安装 TypeScript 语言服务器
    },
  },
}
