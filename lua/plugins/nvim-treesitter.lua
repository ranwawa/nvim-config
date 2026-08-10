-- 折叠 + 高亮依赖 tree-sitter
-- 新版 nvim-treesitter（2026 重构版）：setup 只收 install_dir；安装用 install{}，
-- 且编译 parser 需要系统工具链（tree-sitter-cli / cc / make）
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

    -- 缺编译工具链才提醒（mason 会把它的 bin 加进 PATH，这里要等它完成）
    vim.schedule(function()
      local missing = {}
      if vim.fn.executable("tree-sitter") == 0 then
        table.insert(missing, "tree-sitter-cli（mason-tool-installer 自动装，或 :MasonInstall tree-sitter-cli）")
      end
      if #missing > 0 then
        vim.notify(
          "tree-sitter 工具链缺失：" .. table.concat(missing, "；"),
          vim.log.levels.WARN,
          { title = "nvim-treesitter" }
        )
      end
    end)
  end,
}