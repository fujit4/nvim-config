return {
	-- color scheme
	{
		"sainnhe/gruvbox-material",
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_background = "light"
			vim.g.gruvbox_material_foreground = "hard"
			vim.g.gruvbox_material_enable_bold = 1
			vim.g.gruvbox_material_ui_contrast = "high"
			vim.g.gruvbox_material_disable_italic_comment = 1
			vim.o.background = "light"
			vim.cmd("colorscheme gruvbox-material")
		end,
	},
	{
		"rbtnn/vim-ambiwidth",
		init = function()
			local add_list = {}
			for code = 0x25b2, 0x25c4 do
				local char = vim.fn.nr2char(code)
				if vim.fn.char2nr(char) == code then
					table.insert(add_list, { code, code, 2 })
				end
			end
			for code = 0x25ce, 0x25ce do
				local char = vim.fn.nr2char(code)
				if vim.fn.char2nr(char) == code then
					table.insert(add_list, { code, code, 2 })
				end
			end
			vim.g.ambiwidth_add_list = add_list
		end,
	},
	{
		"kamecha/bimove",
		config = function()
			-- キーマップ設定
			vim.keymap.set("n", "M", "<Plug>(bimove-enter)<Plug>(bimove)", { silent = true })
			vim.keymap.set("n", "<Plug>(bimove)k", "<Plug>(bimove-high)<Plug>(bimove)", { silent = true })
			vim.keymap.set("n", "<Plug>(bimove)j", "<Plug>(bimove-low)<Plug>(bimove)", { silent = true })

			-- ハイライトリンク設定
			vim.api.nvim_set_hl(0, "BimoveHigh", { link = "Search" })
			vim.api.nvim_set_hl(0, "BimoveCursor", { link = "Visual" })
			vim.api.nvim_set_hl(0, "BimoveLow", { link = "Visual" })
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter", -- 挿入モードで読み込み
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP補完
			"hrsh7th/cmp-buffer", -- バッファ内補完
			"hrsh7th/cmp-path", -- パス補完
			"hrsh7th/cmp-cmdline", -- コマンドライン補完
			"L3MON4D3/LuaSnip", -- スニペットエンジン
			"saadparwaiz1/cmp_luasnip", -- LuaSnip用補完
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Tabで確定
					-- Tabで補完候補を「選択していれば」確定にしたい場合は下記
					-- --------------------------------------------------------
					-- ['<Tab>'] = cmp.mapping(function(fallback)
					-- 	if cmp.visible() and cmp.get_selected_entry() then
					-- 		cmp.confirm({ select = false })  -- ←ここが重要
					-- 	else
					-- 		fallback()
					-- 	end
					-- end, { 'i', 's' }),
					-- 以上 ---------------------------------------------------
					['<CR>'] = cmp.mapping(function(fallback)
						if cmp.visible() and cmp.get_selected_entry() then
							cmp.confirm({ select = false }) -- ←ここが重要
						else
							fallback()
						end
					end, { 'i', 's' }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})

			-- `:` cmdline setup.
			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "cmdline" },
					{ name = 'path' }
				}, {
					{
						name = 'cmdline',
						option = {
							ignore_cmds = { 'Man', '!' }
						}
					}
				})
			})

		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"stevearc/conform.nvim",
		cmd = { "ConformInfo", "Format" },
		opts = {
			-- 保存時は自動フォーマットしない
			format_on_save = false,

			-- Prettier を使うファイルタイプ
			formatters_by_ft = {
				javascript      = { "prettier" },
				typescript      = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				css             = { "prettier" },
				html            = { "prettier" },
				json            = { "prettier" },
				yaml            = { "prettier" },
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
	},
	{
		-- gitsigns: 小さな差分や変更の追跡
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
		-- diffview: 大きな差分や履歴を詳細に見る
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory" }, -- 必要なときだけ起動
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("diffview").setup({})
		end
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP補完
		},
		config = function()
			-- 共通設定
			vim.lsp.config('*', {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})

			-- 個別設定
			-- `nvim/after/lsp/<lsp_name>.lua`

			-- 自動起動設定
			local lsp_names = {
				"lua_ls",
				"gopls",
				"ts_ls",
			}
			vim.lsp.enable(lsp_names)

			-- エラーポップアップ表示キー
			vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { noremap = true, silent = true })
			vim.keymap.set('n', '<leader>q', function()
				vim.diagnostic.setqflist()
			end, { noremap = true, silent = true })
			vim.keymap.set('n', '<leader>c', vim.lsp.buf.code_action, { noremap = true, silent = true })
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					theme = "gruvbox-material",
					icons_enabled = false, -- リガチャ・アイコン不要のため
					component_separators = { left = "│", right = "│" },
					section_separators = { left = "", right = "" },
					globalstatus = true, -- ウィンドウごとのステータスラインではなく全体に
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = { { "filename", path = 1 } }, -- 相対パス表示
					lualine_x = { "filetype", "encoding", "fileformat" },
					lualine_y = { "location" },
					lualine_z = {},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			require("lazy").load { plugins = { "markdown-preview.nvim" } }
			vim.fn["mkdp#util#install"]()
		end,
	},
	{
		"Eutrius/Otree.nvim",
		-- lazy = false,
		dependencies = {
			"stevearc/oil.nvim",
		},
		config = function()
			require("Otree").setup()
		end,
		vim.keymap.set('n', '<C-e>', ":OtreeFocus<CR>", { noremap = true, silent = true })
	},
	{
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
							["<Esc>"] = false, -- Esc 無効化
							["q"] = actions.close, -- q で閉じる
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
}
