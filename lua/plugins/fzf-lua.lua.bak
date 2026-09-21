return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("fzf-lua").setup({})
  end,
  keys = {
    { "<leader>ff", function() require("fzf-lua").files() end, desc = "Find files" },
    { "<leader>fg", function() require("fzf-lua").live_grep() end, desc = "Live grep" },
    { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Buffers" },
    { "<leader>fr", function() require("fzf-lua").oldfiles() end, desc = "Recent files" },
    { "<leader>fh", function() require("fzf-lua").helptags() end, desc = "Help tags" },
  },
}
