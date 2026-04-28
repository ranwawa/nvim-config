
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


vim.keymap.set({'n', 'i', 'v'}, '<leader>w', '<cmd>w<CR>', { noremap = true })

-- Command + s 保存文件（macOS 常用快捷键）
-- 普通模式和可视模式下直接保存
vim.keymap.set({'n', 'v'}, '<D-s>', '<cmd>w<CR>', { noremap = true, silent = true })
-- 插入模式下保存并保持在插入模式
vim.keymap.set('i', '<D-s>', '<Esc><cmd>w<CR>a', { noremap = true, silent = true })

-- 备用映射：Ctrl+s 保存（兼容性更好）
vim.keymap.set({'n', 'v'}, '<C-s>', '<cmd>w<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-s>', '<Esc><cmd>w<CR>a', { noremap = true, silent = true })

-- 启用行号
vim.wo.number = true

-- 启用相对行号
vim.wo.relativenumber = true

-- Neovim 0.12 使用内置 treesitter foldexpr，比旧的 nvim_treesitter#foldexpr() 更稳定
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- 配置系统剪贴板，确保同时支持 * 和 + 寄存器
-- 这样无论是使用 pbcopy/pbpaste（macOS）还是 xclip/xsel（Linux）都能正常工作
vim.o.clipboard = 'unnamedplus'

-- 确保在 tmux 中运行时，nvim 能正确检测并使用系统剪贴板
-- 检查是否在 tmux 中运行
-- 退出 nvim 时自动提交并推送配置变更
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    local config_dir = vim.fn.stdpath("config")
    local log_path = vim.fn.stdpath("state") .. "/nvim-config-sync.log"
    local shell_script = string.format([[
mkdir -p %s
cd %s || exit 0

log_failure() {
  timestamp=$(date '+%%Y-%%m-%%d %%H:%%M:%%S')
  step="$1"
  code="$2"
  output="$3"
  {
    printf '%%s\n' "$timestamp"
    printf 'step: %%s\n' "$step"
    printf 'exit_code: %%s\n' "$code"
    printf '%%s\n\n' "$output"
  } >> %s
}

git add -A >/dev/null 2>&1
add_code=$?
if [ "$add_code" -ne 0 ]; then
  add_output=$(git add -A 2>&1)
  log_failure "git add -A" "$add_code" "$add_output"
  exit 0
fi

git diff --cached --quiet >/dev/null 2>&1
diff_code=$?
if [ "$diff_code" -eq 1 ]; then
  commit_output=$(git commit -m 'auto: sync nvim config' 2>&1)
  commit_code=$?
  if [ "$commit_code" -ne 0 ]; then
    log_failure "git commit" "$commit_code" "$commit_output"
    exit 0
  fi
elif [ "$diff_code" -ne 0 ]; then
  diff_output=$(git diff --cached --quiet 2>&1)
  log_failure "git diff --cached --quiet" "$diff_code" "$diff_output"
  exit 0
fi

upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)
if [ -z "$upstream" ]; then
  exit 0
fi

remote_name=${upstream%%/*}
fetch_output=$(git fetch "$remote_name" 2>&1)
fetch_code=$?
if [ "$fetch_code" -ne 0 ]; then
  log_failure "git fetch" "$fetch_code" "$fetch_output"
  exit 0
fi

counts=$(git rev-list --left-right --count "$upstream...HEAD" 2>/dev/null)
counts_code=$?
if [ "$counts_code" -ne 0 ]; then
  log_failure "git rev-list --left-right --count" "$counts_code" "$counts"
  exit 0
fi

behind_count=$(printf '%%s' "$counts" | awk '{print $1}')
ahead_count=$(printf '%%s' "$counts" | awk '{print $2}')

if [ "$behind_count" -gt 0 ]; then
  log_failure "sync skipped" "0" "Upstream $upstream is ahead by $behind_count commit(s); run: git pull --rebase"
  exit 0
fi

if [ "$ahead_count" -gt 0 ]; then
  push_output=$(git push 2>&1)
  push_code=$?
  if [ "$push_code" -ne 0 ]; then
    log_failure "git push" "$push_code" "$push_output"
  fi
fi
]], vim.fn.shellescape(vim.fn.stdpath("state")), vim.fn.shellescape(config_dir), vim.fn.shellescape(log_path))

    local handle
    handle = vim.uv.spawn("/bin/sh", {
      args = { "-lc", shell_script },
      detached = true,
      stdio = { nil, nil, nil },
    }, function()
      if handle and not handle:is_closing() then
        handle:close()
      end
    end)

    if handle then
      handle:unref()
    end
  end,
})

if os.getenv("TMUX") then
  -- 为了在 tmux 中更好地支持剪贴板，我们可以尝试直接使用系统命令
  -- 这对于通过 SSH 连接时的剪贴板转发可能更有效
  vim.g.clipboard = {
    name = "tmux",
    copy = {
      ["+"] = {"tmux", "load-buffer", "-w", "-"},
      ["*"] = {"tmux", "load-buffer", "-w", "-"},
    },
    paste = {
      ["+"] = {"tmux", "show-buffer"},
      ["*"] = {"tmux", "show-buffer"},
    },
  }
end
