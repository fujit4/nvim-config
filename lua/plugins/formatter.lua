return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo", "Format" },
  opts = {
    -- 保存時は自動フォーマットしない
    format_on_save = false,

    -- Prettier を使うファイルタイプ
    formatters_by_ft = {
      javascript        = { "prettier" },
      typescript        = { "prettier" },
      javascriptreact   = { "prettier" },
      typescriptreact   = { "prettier" },
      css               = { "prettier" },
      html              = { "prettier" },
      json              = { "prettier" },
      yaml              = { "prettier" },
    },
  },
  config = function(_, opts)
    -- conform.nvim をセットアップ
    require("conform").setup(opts)

    -- 手動フォーマット用コマンドを定義
    vim.api.nvim_create_user_command("Format", function()
      require("conform").format({
        async = true,
        lsp_fallback = true,
      })
    end, { desc = "Format current buffer with conform.nvim" })
  end,
}

