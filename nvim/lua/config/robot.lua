local custom_menu = require('features/custom_menu').custom_menu

local plugins = {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
    opts = {
      custom_handlers = {
        -- Look out for raw HTML/XML tags and treat them as collapsible blocks
        html = {
          extends = true,
          -- You can configure specific tag behavior here if render-markdown
            -- supports custom tag folding natively in your current version
          }
        },
        -- Standard setup to turn raw blocks into clean UI elements
        heading = { sign = true, icons = { "   ", "   ", "   " } },
        code = { left_pad = 2, right_pad = 2 },
      }
    },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" }, -- Renders beautiful markdown inside chat splits
      },
    },
    config = function()
      require("codecompanion").setup({
          ui = {
            code_block = 'codeblock',
            chat = {
              win_opts = {
                winblend = 0,
              },
            },
          },
          display = {
            chat = {
              show_tokens = true,
              window = {
                layout = "buffer", -- Options include float|vertical|horizontal|buffer
                -- other options...
              },
            },
          },
          -- 1. Explicitly turn off Copilot so it never loads
          adapters = {
            copilot = false,

            -- 2. Define your custom adapter
            http = {
              coder_wb = function()
                return require("codecompanion.adapters").extend("openai_compatible", {
                    name = "coder_wb",
                    formatted_name = "CoderWB",
                    env = {
                      url = "https://llm.wb.ru/api/v1",
                      api_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJwMzhsYXBPTExJM283ZkU2eWhzdWljSmNYaHZyRVVBcSJ9.hFQu6zCzLGGc3-Y13RGPt0g_nTSlitOFFrxJYXpDerA",
                      chat_url = "/chat/completions",
                    },
                    schema = {
                      model = {
                        default = "coder-medium",
                        choices = { "coder-medium" }, -- Explicitly list to avoid API model fetching
                      },
                    },
                  })
              end,
            },
          },

          -- 3. Point both interactions to your adapter
          interactions = {
            chat = {
              adapter = "coder_wb",
              tools = {
                ["grep_search"] = {},   -- runs ripgrep, requires ripgrep installed
                ["cmd_runner"] = {
                  opts = { require_confirmation = false },  -- asks you before running
                },
                ["read_file"] = {},
                ["run_command"] = {
                  opts = {
                    require_approval_before = false,
                  },
                },
                opts = {
                  auto_tool_mode = true, -- Enables or disables automatic tool execution
                },
              },
              -- keymaps = {
              --   toggle = {
              --     modes = { n = true, i = true },
              --     lhs = "<F6>",
              --     rhs = function()
              --       require("codecompanion").toggle()
              --     end,
              --     desc = "Toggle chat buffer",
              --   },
              -- },
            },
            inline = { adapter = "coder_wb" },
            agent = { adapter = "coder_wb" },
          },
        })
    end,
  }

}

local callbackOnEnter = function() -- сразу показываем что Sending...
  local buf = vim.api.nvim_get_current_buf()
  local send_indicator_ns = vim.api.nvim_create_namespace("cc_send_indicator")
  local indicator_mark_id = nil

  local function send_message()
    local chat = require("codecompanion").last_chat()
    if not chat then
      return
    end

    -- Показываем индикатор в конце буфера
    local last_line = vim.api.nvim_buf_line_count(buf) - 1
    indicator_mark_id = vim.api.nvim_buf_set_extmark(buf, send_indicator_ns, last_line, 0, {
        virt_text = { { " ⏳ Отправка...", "Comment" } },
        virt_text_pos = "eol",
      })

    vim.schedule(function()
      chat:submit()
    end)
  end

  -- Normal mode
  vim.keymap.set("n", "<Enter>", send_message, { buffer = true, desc = "Send message" })
  vim.keymap.set("i", "<C-s>", send_message, { buffer = true, desc = "Send message" })

  -- Убираем индикатор при изменении буфера (когда придёт ответ)
  vim.api.nvim_create_autocmd("TextChanged", {
      buffer = buf,
      callback = function()
        if indicator_mark_id then
          vim.api.nvim_buf_del_extmark(buf, send_indicator_ns, indicator_mark_id)
          indicator_mark_id = nil
        end
      end,
    })
end

local init_config = function()
  vim.keymap.set({ "t", "i", "v", "n" }, "<F6>", function()
    require("codecompanion").toggle()
  end, { desc = "Toggle Robot" })

  vim.api.nvim_create_autocmd("Filetype", {
      pattern = "codecompanion",
      callback = function(args)
        callbackOnEnter()
        vim.keymap.set("i", "<C-b>", "#{buffer}", { buffer = args.buf })
      end,
      })
  end

return {
  plugins = plugins,
  init_config = init_config,
}
