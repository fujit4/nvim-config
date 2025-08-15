-- plugins/git.lua
return {
  -- gitsigns: 小さな差分や変更の追跡
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()


      require("gitsigns").setup({
        signs = {
          add          = { text = "+" },
          change       = { text = "~" },
          delete       = { text = "-" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
        },

	numhl = true,
        current_line_blame = false, -- 現行行のblameを表示しない
      })
      -- diffやステージングなどの操作をスムーズに
      vim.api.nvim_set_keymap("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", { noremap = true, silent = true }) -- 現在のhunkをステージ
      vim.api.nvim_set_keymap("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { noremap = true, silent = true }) -- 現在のhunkをリセット
      vim.api.nvim_set_keymap("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { noremap = true, silent = true }) -- 差分プレビュー
      vim.api.nvim_set_keymap("n", "<leader>gb", ":Gitsigns blame_line<CR>", { noremap = true, silent = true }) -- 現行行のblame表示
      vim.api.nvim_set_keymap("n", "<leader>gd", ":Gitsigns diffthis<CR>", { noremap = true, silent = true }) -- 現在のファイルのdiff表示
    end
  },

  {
	  "nvim-lua/plenary.nvim"
  },

  -- diffview: 大きな差分や履歴を詳細に見る
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" }, -- 必要なときだけ起動
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("diffview").setup({})
    end
  }
}

