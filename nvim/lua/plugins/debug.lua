return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- UI
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',

    -- Debug adapter management
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Language-specific DAPs
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    -- Mason DAP setup
    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'debugpy',    -- Python
        'cpptools',   -- C/C++
      },
    }

    -- DAP UI setup
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = '⏪',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Keymap for toggling DAP UI
    vim.keymap.set('n', '<F7>', function() dapui.toggle() end, { desc = 'Debug: Toggle UI' })

    -- Auto open/close UI
    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
    dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
    dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

    ----------------------------------------------------------------
    -- 🐍 Python Debugging
    ----------------------------------------------------------------
    -- Use system python inside WSL2
    local python_path = vim.fn.exepath('python3')
    require('dap-python').setup(python_path)

    ----------------------------------------------------------------
    -- 🧠 C/C++ Debugging
    ----------------------------------------------------------------
    local gdb_path = vim.fn.exepath("gdb")
    local cpptools_path = vim.fn.stdpath("data") .. '/mason/bin/OpenDebugAD7'

    dap.adapters.cppdbg = {
      id = 'cppdbg',
      type = 'executable',
      command = cpptools_path,
      options = { detached = false },
    }

    dap.configurations.cpp = {
      {
        name = "Launch C/C++ executable",
        type = "cppdbg",
        request = "launch",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
        MIMode = "gdb",
        miDebuggerPath = gdb_path,
      },
    }
    dap.configurations.c = dap.configurations.cpp

    ----------------------------------------------------------------
    -- 🧩 Golang Debugging (optional)
    ----------------------------------------------------------------
    -- require('dap-go').setup()
  end,
}
