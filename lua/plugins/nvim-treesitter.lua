-- 折叠 + 高亮依赖 tree-sitter
-- 新版 nvim-treesitter（2026 重构版）：setup 只收 install_dir；安装用 install{}，
-- 且从源码编译 parser 需要系统工具链（tree-sitter-cli / cc / make）
local tools = {
  { cmd = "tree-sitter",   type = "CLI",        provided_by = "mason-tool-installer 自动安装" },
  { cmd = "cc",            type = "C 编译器",    provided_by = "系统包: sudo apt install build-essential" },
  { cmd = "make",          type = "构建工具",    provided_by = "系统包: sudo apt install build-essential" },
}

-- 启动时探测工具链，缺失则补装/提醒
if vim.fn.executable("tree-sitter") == 0 or vim.fn.executable("make") == 0 then
  vim.schedule(function()
    vim.notify("tree-sitter 工具链缺失：检查 " .. vim.inspect(tools), vim.log.levels.WARN, { title = "nvim-treesitter" })
  end)
end

return {
  "nvim-treesitter/nvim-treesitter",
  -- 新版本 build 在插件更新后自动跑 :TSUpdate，sync 已安装 parser
  build = ":TSUpdate",
  -- 新版 API：setup 只接收 install_dir，安装用 install{}
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site"),
    })

    -- 自动安装常用语言的 parser（幂等：已装则跳过）
    require("nvim-treesitter").install {
      "typescript",
      "tsx",
      "javascript",
      "lua",
      "vim",
      "vimdoc",
      "bash",
      "json",
      "markdown",
      "python",
      "go",
      "rust",
      "yaml",
      "toml",
    }
  end,
}