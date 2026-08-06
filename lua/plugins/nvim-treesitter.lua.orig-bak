local M = {
	"nvim-treesitter/nvim-treesitter",
	branch = "master", -- master 分支使用旧 API，无需 tree-sitter CLI
	build = function()
		require("nvim-treesitter.install").update({ with_sync = true })()
	end,
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
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
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
		})
	end,
}

return { M }
