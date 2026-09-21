-- 列表类面板（列表结果）的开关映射
-- 约定：<leader>x 作为「列表与诊断」分组，与 <leader>f（查找）、<leader>g（Git）并列
-- 背景：vim.lsp.buf.references() 等把结果写进 quickfix（全局，:copen/:cclose）；
--      location list 是它的 window-local 版本（:lopen/:lclose）

-- 列表当前已显示 → 关闭；否则 → 打开
-- 用 getqflist/getloclist 的 winid 字段判断，比数窗口或看 buffer 名更可靠
local function toggle_list(get_list, open_cmd, close_cmd)
  return function()
    local winid = get_list({ winid = 0 }).winid
    if winid ~= 0 and vim.api.nvim_win_is_valid(winid) then
      vim.cmd(close_cmd)
    else
      -- 空 loclist 调 :lopen 会抛 E776，这里降级成一句提示而不是报错
      -- （空 quickfix 的 :copen 是允许的，会开一个空窗口）
      local ok = pcall(vim.cmd, open_cmd)
      if not ok then
        vim.notify("No location list entries yet", vim.log.levels.INFO)
      end
    end
  end
end

vim.keymap.set("n", "<leader>xq", toggle_list(vim.fn.getqflist, "copen", "cclose"), {
  desc = "Toggle quickfix list",
})

vim.keymap.set("n", "<leader>xl", toggle_list(function(opts)
  return vim.fn.getloclist(0, opts)
end, "lopen", "lclose"), {
  desc = "Toggle location list",
})
