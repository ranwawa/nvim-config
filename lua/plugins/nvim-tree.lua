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
                dotfiles = false,
                git_ignored = false,
            },
            on_attach = function(bufnr)
                local api = require("nvim-tree.api")
                api.config.mappings.default_on_attach(bufnr)
                vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, { buffer = bufnr, desc = "Toggle Hidden Files" })
                vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, { buffer = bufnr, desc = "Toggle Git Ignored Files" })
            end,
        })

        -- 打开/关闭目录树
        vim.keymap.set({'n', 'i'}, '<leader>e', '<cmd>NvimTreeToggle<CR>', { noremap = true, silent = true, desc = "Toggle NvimTree" })
        -- 查找当前文件在目录树中的位置
        vim.keymap.set({'n', 'i'}, '<leader>f', '<cmd>NvimTreeFindFile<CR>', { noremap = true, silent = true, desc = "Find file in NvimTree" })

        -- 当 nvim-tree 是最后一个窗口时自动退出
        vim.api.nvim_create_autocmd("QuitPre", {
            callback = function()
                local tree_wins = {}
                local floating_wins = {}
                local wins = vim.api.nvim_list_wins()
                for _, w in ipairs(wins) do
                    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
                    if bufname:match("NvimTree_") ~= nil then
                        table.insert(tree_wins, w)
                    end
                    if vim.api.nvim_win_get_config(w).relative ~= '' then
                        table.insert(floating_wins, w)
                    end
                end
                if #wins - #floating_wins - #tree_wins == 1 then
                    for _, w in ipairs(tree_wins) do
                        vim.api.nvim_win_close(w, true)
                    end
                end
            end,
        })
    end,
    -- 启动时默认打开目录树
    init = function()
        -- 当打开 Neovim 且没有参数时，默认打开目录树
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function(data)
                -- 如果是目录或没有文件参数
                local directory = vim.fn.isdirectory(data.file) == 1
                local no_file = data.file == ""
                if directory or no_file then
                    -- 打开目录树
                    require("nvim-tree.api").tree.open()
                end
            end,
        })
    end,
}
