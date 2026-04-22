return {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
        { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Git diff (all files)" },
        { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "Git file history" },
        { "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "Close diffview" },
    },
    config = function()
        require("diffview").setup({
            view = {
                default = { layout = "diff2_horizontal" },
                file_history = { layout = "diff2_horizontal" },
            },
        })
    end,
}
