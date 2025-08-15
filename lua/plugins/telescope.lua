-- plugins/telescope.lua
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    -- システムのエディターでファイルを開くアクション
    local function open_with_system_editor(prompt_bufnr)
      local entry = action_state.get_selected_entry()
      actions.close(prompt_bufnr)
      if entry and (entry.path or entry.filename) then
        local filepath = entry.path or entry.filename
        -- Windows: "start" を使って開く（cmd.exe経由）
		vim.fn.jobstart({ "cmd.exe", "/c", "start", "", filepath }, { detach = true })
      end
    end

	require("telescope").setup({
		defaults = {
			layout_strategy = "bottom_pane",
			layout_config = {
				height = 0.5,
				prompt_position = "top",
			},
			sorting_strategy = "ascending",
			previewer = false,
			mappings = {
				n = {
					["s"] = open_with_system_editor,
					["<Esc>"] = false,           -- Esc 無効化
					["q"] = actions.close,       -- q で閉じる
				},
			},
		},
	})

 	-- キーマッピング
	local builtin = require("telescope.builtin")
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- ファイル・バッファ
    map("n", "<leader>f", builtin.find_files, opts)
    map("n", "<leader>b", builtin.buffers, opts)
    map("n", "<leader>rg", builtin.live_grep, opts)

    -- LSP系（<leader>l で統一）
    map("n", "<leader>ld", builtin.lsp_definitions, opts)
    map("n", "<leader>lr", builtin.lsp_references, opts)
    map("n", "<leader>li", builtin.lsp_implementations, opts)
    map("n", "<leader>ls", builtin.lsp_document_symbols, opts)

    -- Git系
    map("n", "<leader>gic", builtin.git_commits, opts)
    map("n", "<leader>gib", builtin.git_branches, opts)
    map("n", "<leader>gis", builtin.git_status, opts)
  end,
}

