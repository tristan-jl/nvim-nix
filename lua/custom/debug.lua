require("lze").load {
  {
    "nvim-dap",
    for_cat = "full",
    keys = {
      { "<space>bp", desc = "Toggle breakpoint" },
      { "<space>gb", desc = "Run to cursor" },
      { "<space>?", desc = "Eval var under cursor" },
      { "<F1>", desc = "Debug: Continue" },
      { "<F2>", desc = "Debug: Step Into" },
      { "<F3>", desc = "Debug: Step Over" },
      { "<F4>", desc = "Debug: Step Out" },
      { "<F5>", desc = "Debug: Step Back" },
      { "<F13>", desc = "Debug: Restart" },
    },
    load = function(name)
      vim.cmd.packadd(name)
      vim.cmd.packadd "nvim-dap-ui"
      vim.cmd.packadd "nvim-dap-virtual-text"
      vim.cmd.packadd "nvim-nio"
    end,
    after = function(_)
      local dap = require "dap"
      local ui = require "dapui"

      require("dapui").setup {
        icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
        controls = {
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
            disconnect = "⏏",
          },
        },
      }

      require("nvim-dap-virtual-text").setup {
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,
        display_callback = function(variable, buf, stackframe, node, options)
          if options.virt_text_pos == "inline" then
            return " = " .. variable.value
          else
            return variable.name .. " = " .. variable.value
          end
        end,
        virt_text_pos = vim.fn.has "nvim-0.10" == 1 and "inline" or "eol",
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      }

      -- Codelldb adapter for Rust
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "lldb-dap",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.rust = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      -- Keymaps
      vim.keymap.set("n", "<space>bp", dap.toggle_breakpoint)
      vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

      vim.keymap.set("n", "<space>?", function()
        require("dapui").eval(nil, { enter = true })
      end)

      vim.keymap.set("n", "<F1>", dap.continue)
      vim.keymap.set("n", "<F2>", dap.step_into)
      vim.keymap.set("n", "<F3>", dap.step_over)
      vim.keymap.set("n", "<F4>", dap.step_out)
      vim.keymap.set("n", "<F5>", dap.step_back)
      vim.keymap.set("n", "<F13>", dap.restart)

      -- Auto open/close UI
      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
  {
    "nvim-dap-python",
    for_cat = "full",
    on_plugin = { "nvim-dap" },
    after = function(_)
      require("dap-python").setup "python"
      require("dap-python").test_runner = "pytest"
    end,
  },
}
