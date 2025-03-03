-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- 设置 tab 宽度为 2 个空格
vim.opt.tabstop = 2
-- 当插入 tab 时，将其转换为相应数量的空格
vim.opt.expandtab = true
-- 自动缩进时使用的空格数为 2
vim.opt.shiftwidth = 2
-- 新行的缩进继承前一行的缩进
vim.opt.softtabstop = 2

-- 映射 <leader>y 到复制当前行到系统剪贴板
vim.keymap.set('n', '<leader>y', '"+yy', { noremap = true, silent = true })
-- 映射 <leader>y 在可视模式下复制选中内容到系统剪贴板
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, silent = true })

-- 映射 <leader>s 到保存命令
vim.keymap.set('n', '<leader>s', '<cmd>w<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<D-s>', '<cmd>w<CR>', { noremap = true, silent = true })
vim.keymap.set('v', '<D-s>', '<cmd>w<CR>', { noremap = true, silent = true })
