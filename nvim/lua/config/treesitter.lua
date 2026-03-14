return {
    -- sudo apt install tree-sitter-cli tar curl
    { 'nvim-treesitter/nvim-treesitter',
      lazy = false,
      build = ':TSUpdate',
      config = function()
        require("nvim-treesitter").setup({
          ensure_installed = { 'javascript', 'awk', 'bash', 'c', 'cmake', 'cpp', 'css', 'csv', 'diff', 'dockerfile',
            'fish', 'git_config', 'git_rebase', 'gitattributes', 'gitcommit', 'gitignore', 'go', 'html', 'http', 'ini', 'jq', 'jsdoc',
            'json', 'json5', 'jsx', 'lua', 'make', 'markdown', 'markdown_inline', 'printf', 'regex', 'scss', 'typescript', 'vim',
          'vimdoc', 'vue', 'yaml' },
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
          },
          indent = { enable = true },
          textobjects = { enable = true },
        })
      end
    },

    { "MeanderingProgrammer/treesitter-modules.nvim",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      opts = {
        incremental_selection = {
          enable = true,
          disable = false,
          keymaps = {
            init_selection = false,
            node_incremental = "v",
            scope_incremental = false,
            node_decremental = "V",
          },
        },
      },
    },
}
