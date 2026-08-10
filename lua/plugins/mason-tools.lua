-- 工具链自动安装（跨机器同步用）
-- Mason 负责 npm/二进制类工具：tree-sitter-cli（新版 nvim-treesitter 编译 parser 的必需要）
-- 注：gcc / make 属于系统编译器，Mason 无法安装，需各机器自行 `sudo apt install build-essential`（见 mason-tool-installer 注释）
return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "williamboman/mason.nvim" },
  opts = {
    ensure_installed = {
      "tree-sitter-cli", -- 编译 tree-sitter parser 的 CLI（nvim-treesitter 新版依赖）
    },
    auto_update = true,
    run_on_start = true, -- nvim 启动时自动补装缺失工具（跨机器同步的关键）
  },
}