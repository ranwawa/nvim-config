return {
    "tpope/vim-fugitive",
    cmd = {
        "Git",
        "G",
        "Gdiffsplit",
        "Gvdiffsplit",
        "Gedit",
        "Gread",
        "Gwrite",
        "Ggrep",
        "GMove",
        "GRename",
        "GDelete",
        "GBrowse",
    },
    keys = {
        { "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
        { "<leader>gf", "<cmd>Gdiffsplit<CR>", desc = "Git diff current file" },
    },
}
