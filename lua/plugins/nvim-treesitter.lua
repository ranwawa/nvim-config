local M = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			-- 安装目录，默认值即可
			-- install_dir = vim.fn.stdpath("data") .. "/site",
		})

		-- 安装常用解析器（异步）
		require("nvim-treesitter").install({
			"javascript",
			"html",
			"json",
			"jsonc",
			"lua",
			"markdown",
			"markdown_inline",
			"tsx",
			"typescript",
			"yaml",
		})
	end,
}

return { M }
