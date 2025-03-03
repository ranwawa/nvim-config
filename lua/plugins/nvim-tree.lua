return {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        'nvim-tree/nvim-web-devicons', -- 可选，用于显示文件图标
    },
    config = function()
        require('nvim-tree').setup({
            sort_by = "case_sensitive",
            view = {
                width = 30,
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = true,
            },
        })

        vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { noremap = true, silent = true })
        vim.keymap.set('i', '<leader>e', '<cmd>NvimTreeToggle<CR>', { noremap = true, silent = true })
    end,
}
