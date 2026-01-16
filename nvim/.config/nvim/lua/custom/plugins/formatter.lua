return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local conform = require 'conform'

    conform.setup {
      formatters_by_ft = {
        python = { 'isort', 'black' },
        lua = { 'stylua' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        go = { 'gofmt' },
        markdown = { 'prettier' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        graphql = { 'prettier' },
        svelte = { 'prettier' },
      },

      format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
    }
  end,
}
