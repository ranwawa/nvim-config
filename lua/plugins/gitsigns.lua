return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("gitsigns").setup({
            signs = {
                add          = { text = "+" },
                change       = { text = "~" },
                delete       = { text = "_" },
                topdelete    = { text = "^" },
                changedelete = { text = "~" },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local opts = function(desc)
                    return { buffer = bufnr, noremap = true, silent = true, desc = desc }
                end

                -- hunk 导航
                vim.keymap.set("n", "]c", function()
                    if vim.wo.diff then return "]c" end
                    vim.schedule(function() gs.next_hunk() end)
                    return "<Ignore>"
                end, { buffer = bufnr, expr = true, desc = "Next hunk" })

                vim.keymap.set("n", "[c", function()
                    if vim.wo.diff then return "[c" end
                    vim.schedule(function() gs.prev_hunk() end)
                    return "<Ignore>"
                end, { buffer = bufnr, expr = true, desc = "Prev hunk" })

                -- hunk 操作
                vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts("Stage hunk"))
                vim.keymap.set("n", "<leader>hr", gs.reset_hunk, opts("Reset hunk"))
                vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, opts("Undo stage hunk"))
                vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts("Preview hunk"))
                vim.keymap.set("n", "<leader>hb", function() gs.blame_line({ full = true }) end, opts("Blame line"))
                vim.keymap.set("n", "<leader>hd", gs.diffthis, opts("Diff this file"))
            end,
        })
    end,
}
