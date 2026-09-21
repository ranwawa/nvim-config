-- 这些目录不参与搜索（.gitignore 里通常也有，这里再显式声明一次作为兜底）
local ignore_dirs = {
  ".git",
  ".next",
  ".pnpm-store",
  "build",
  "coverage",
  "dist",
  "node_modules",
  "out",
}

local rg_globs = {}
local file_ignore_patterns = {}
for _, dir in ipairs(ignore_dirs) do
  table.insert(rg_globs, ("--glob='!%s'"):format(dir))
  table.insert(file_ignore_patterns, ("%s/"):format(dir))
end

return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("fzf-lua").setup({
      files = {
        file_ignore_patterns = file_ignore_patterns,
      },
      grep = {
        rg_opts = table.concat({
          "--column --line-number --no-heading --color=always --smart-case",
          "--max-columns=4096",
          table.concat(rg_globs, " "),
          "-e",
        }, " "),
      },
    })
  end,
  keys = {
    { "<leader>ff", function() require("fzf-lua").files() end, desc = "Find files" },
    { "<leader>fg", function() require("fzf-lua").live_grep() end, desc = "Live grep" },
    { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Buffers" },
    { "<leader>fr", function() require("fzf-lua").oldfiles() end, desc = "Recent files" },
    { "<leader>fh", function() require("fzf-lua").helptags() end, desc = "Help tags" },
  },
}
