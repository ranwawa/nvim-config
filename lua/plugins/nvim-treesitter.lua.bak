local M = {
    "nvim-treesitter/nvim-treesitter",
    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    config = function()
        require("nvim-treesitter.configs").setup({
            -- 确保安装 Markdown 解析器
            ensure_installed = { "markdown", "markdown_inline", "lua", "javascript", "typescript" },

            -- 启用语法高亮
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            fold = {
                 enable = true, -- 启用代码折叠
            },
            -- 其他配置项...
        })
    end,
}

return { M }
