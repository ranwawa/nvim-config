-- DAP: 断点调试（断点 / 单步 / 变量 / 调用栈）
-- 链路：nvim-dap（协议+UI 状态）→ js-debug 适配器（TCP server）→ Node Inspector（--inspect 端口）
--
-- 适配器为官方离线包，已解压到 ~/.local/share/js-debug/js-debug（入口 src/dapDebugServer.js），
-- 不依赖 VS Code，也不需要在插件目录里 npm install。
--
-- 本项目（zmn-delivery-ops）调试步骤：
--   1. 带 inspector 启动本地服务（注意：pnpm dev 的 cross-env 会覆盖 NODE_OPTIONS，故直接用 node 启动）：
--        NODE_ENV=development DEBUG_MODE=true \
--        NODE_OPTIONS="--inspect=127.0.0.1:9229 --max-old-space-size=8192" node server.js
--   2. nvim 打开源文件，光标到目标行 <leader>db 打断点
--   3. <leader>dc 选择 "Attach: Node Inspector (9229)"，再在浏览器触发接口请求
--      （Route Handler 在服务端进程内执行，断点会直接命中，可单步进到 infrastructure/service 层）

local JS_DEBUG_SERVER =
  vim.fn.expand("~/.local/share/js-debug/js-debug/src/dapDebugServer.js")
local INSPECT_PORT = 9229

local SOURCE_MAP_LOCATIONS = {
  "${workspaceFolder}/**",
  "!**/node_modules/**",
}
local SKIP_FILES = { "<node_internals>/**", "**/node_modules/**" }

local function setup_dap()
  local dap = require("dap")
  local dapui = require("dapui")

  -- js-debug 适配器：以 server 模式监听随机端口，nvim-dap 通过 TCP 与之通信
  dap.adapters["pwa-node"] = {
    type = "server",
    host = "127.0.0.1",
    port = "${port}",
    executable = {
      command = "node",
      args = { JS_DEBUG_SERVER, "${port}" },
    },
  }

  local attach = {
    type = "pwa-node",
    request = "attach",
    name = "Attach: Node Inspector (" .. INSPECT_PORT .. ")",
    port = INSPECT_PORT,
    cwd = "${workspaceFolder}",
    -- Next dev（Turbopack）会把 src 编译到 .next/dev/server/chunks 并配 indexed source map，
    -- 需打开 sourceMaps 才能把断点落在原始 .ts 上
    sourceMaps = true,
    resolveSourceMapLocations = SOURCE_MAP_LOCATIONS,
    skipFiles = SKIP_FILES,
    restart = false,
  }

  local launch = {
    type = "pwa-node",
    request = "launch",
    name = "Launch: node server.js (Next dev)",
    program = "${workspaceFolder}/server.js",
    cwd = "${workspaceFolder}",
    runtimeExecutable = "node",
    runtimeArgs = { "--max-old-space-size=8192" },
    env = { NODE_ENV = "development", DEBUG_MODE = "true" },
    sourceMaps = true,
    resolveSourceMapLocations = SOURCE_MAP_LOCATIONS,
    skipFiles = SKIP_FILES,
  }

  for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
    dap.configurations[lang] = { launch, attach }
  end

  -- dap-ui 打开时自动刷新布局，并在退出调试会话时收尾
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  -- 断点行显示红色圆点
  vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
  vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual" })
  vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo" })

  local map = vim.keymap.set
  map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP 打断点/取消" })
  map("n", "<leader>dB", function()
    dap.set_breakpoint(vim.fn.input("断点条件: "))
  end, { desc = "DAP 条件断点" })
  map("n", "<leader>dc", dap.continue, { desc = "DAP 启动/继续" })
  map("n", "<leader>dC", function()
    dap.run_to_cursor()
  end, { desc = "DAP 运行到光标" })
  map("n", "<leader>di", dap.step_into, { desc = "DAP 单步进入" })
  map("n", "<leader>do", dap.step_over, { desc = "DAP 单步跳过" })
  map("n", "<leader>dO", dap.step_out, { desc = "DAP 单步跳出" })
  map("n", "<leader>dl", dap.run_last, { desc = "DAP 重复上次会话" })
  map("n", "<leader>dr", function()
    dap.repl.toggle()
  end, { desc = "DAP 打开 REPL" })
  -- 求值查看：浮窗显示结果（对象/数组可直接展开看层级，比在 Scopes 里逐层点更快）
  map({ "n", "v" }, "<leader>de", function()
    dapui.eval(nil, { enter = true, context = "repl" })
  end, { desc = "DAP 求值选中表达式" })
  map("n", "<leader>dE", function()
    dapui.eval(vim.fn.input("表达式: "), { enter = true, context = "repl" })
  end, { desc = "DAP 求值输入表达式" })
  map("n", "<leader>du", dapui.toggle, { desc = "DAP 切换 UI" })
  map("n", "<leader>dt", dap.terminate, { desc = "DAP 结束会话" })
  map("n", "<leader>dx", function()
    dap.clear_breakpoints()
  end, { desc = "DAP 清空断点" })
end

return {
  {
    "mfussenegger/nvim-dap",
    lazy = false, -- 启动即注册适配器，避免首次 <leader>dc 时配置未就绪
    dependencies = {
      { "nvim-neotest/nvim-nio" }, -- nvim-dap-ui 的运行期依赖
      {
        "rcarriga/nvim-dap-ui",
        config = function()
          require("dapui").setup()
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {}, -- 断点处内联显示变量值
      },
    },
    config = setup_dap,
  },
}
