return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local conform = require('conform')
    
    conform.setup({
      formatters_by_ft = {
        -- JSON格式化配置
        json = { 'prettier', 'jq' },
        jsonc = { 'prettier' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        markdown = { 'prettier' },
        yaml = { 'prettier' },
        
        -- 如果没有找到格式化器，使用这些通用格式化器
        lua = { 'stylua' },
        python = { 'black' },
        go = { 'gofmt', 'goimports' },
        rust = { 'rustfmt' },
      },
      
      -- 自定义格式化器
      formatters = {
        -- 定义jq格式化器（使用系统jq命令）
        jq = {
          command = 'jq',
          args = { '.' },
          stdin = true,
        },
      },
      
      -- 格式化选项
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    })

    -- 设置格式化快捷键
    vim.keymap.set({ 'n', 'v' }, '<leader>fm', function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      })
    end, { desc = 'Format file or range (in visual mode)' })

    -- JSON特定快捷键（与之前保持一致）
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'json',
      callback = function()
        vim.keymap.set('n', '<leader>fj', function()
          conform.format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 500,
          })
        end, { buffer = true, desc = 'Format JSON file' })
        
        vim.keymap.set('v', '<leader>fj', function()
          conform.format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 500,
            range = true,
          })
        end, { buffer = true, desc = 'Format selected JSON' })
      end,
    })
  end,
}