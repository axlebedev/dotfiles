local custom_menu = require('features/custom_menu').custom_menu

local menuOpts = {
  {
    name = '#{buffer}',
    callback = function() vim.api.nvim_feedkeys('a#{buffer}', 'i', false) end
  },
  {
    name = '@{agent}',
    callback = function() vim.api.nvim_feedkeys('a@{agent}', 'i', false) end
  },
}

local plugins = {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
    opts = {
      heading = {
        sign = true,
        icons = { "   ", "   ", "   " },
      },
      code = { language_icon = false },

      file_types = { "markdown", "codecompanion" },
    },
  },
{
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
  },
  config = function()
    require("codecompanion").setup({
      -- Note: approval_mode belongs to the tools configuration, not the top level
      interactions = {
        chat = {
          tools = {
            opts = {
              -- Use "auto" instead of "yolo": auto mode automatically applies file edits,
              -- but still asks for confirmation before executing shell commands, which is safer
              approval_mode = "auto",
              default_tools = {
                "insert_edit_into_file",
                "read_file",      -- Agent can read any file in the project
                "grep_search",    -- Requires ripgrep, search code content by text
                "file_search",    -- Find files by file name
              },
            },
            -- Key fix: explicitly disable confirmations before and after editing for this tool
            ["insert_edit_into_file"] = {
              opts = {
                require_approval_before = false,  -- No confirmation before editing
                require_confirmation_after = false, -- No confirmation after editing; write directly to disk
              },
            },
            ["read_file"] = {
              opts = { require_approval_before = false },
            },
            ["grep_search"] = {
              opts = { require_approval_before = false },
            },
            ["file_search"] = {
              opts = { require_approval_before = false },
            },
          },
          -- Your adapter configuration remains unchanged
          adapter = "coder_wb",
        },
        inline = { adapter = "coder_wb" },
      },
      -- Your adapters configuration remains unchanged
      adapters = {
        http = {
          coder_wb = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "coder_wb",
              formatted_name = "CoderWB",
              opts = { tools = true },
              env = {
                url = "https://llm.wb.ru/api/v1",
                api_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJwMzhsYXBPTExJM283ZkU2eWhzdWljSmNYaHZyRVVBcSJ9.hFQu6zCzLGGc3-Y13RGPt0g_nTSlitOFFrxJYXpDerA",
                chat_url = "/chat/completions",
              },
              schema = {
                model = {
                  default = "coder-medium",
                  choices = { "coder-medium" },
                },
              },
            })
          end,
        },
      },
      -- Your display configuration remains unchanged
      display = {
        chat = {
          show_tokens = true,
          window = { buflisted = true, layout = "buffer" },
          show_header_separator = false,
        },
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
    require("codecompanion").chat()
  end, { desc = "Toggle Robot" })

  vim.api.nvim_create_autocmd("Filetype", {
      pattern = "codecompanion",
      callback = function(args)
        callbackOnEnter()
        vim.keymap.set("i", "<C-b>", "#{buffer}", { buffer = args.buf })
        vim.keymap.set("n", "<leader>w", "<CR>", { buffer = args.buf })
        vim.keymap.set("n", "<leader>r", function() custom_menu(menuOpts) end, { buffer = args.buf })

        vim.api.nvim_feedkeys('gty', 'i', false)
      end,
    })
end

return {
  plugins = plugins,
  init_config = init_config,
}
