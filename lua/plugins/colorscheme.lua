-- lua/plugins/colorscheme.lua
--
return {
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
}

-- return {
--   {
--     "sainnhe/everforest",
--     lazy = false,
--     priority = 1000,
--     config = function()
--       -- 薄め・柔らかい light に最適な設定
--       vim.g.everforest_background = "soft"     -- soft / medium / hard
--       vim.g.everforest_better_performance = 1  -- 余計な処理を省いて軽量化
--       vim.g.everforest_enable_italic = 0       -- 必要なら 1 に
--       vim.g.everforest_transparent_background = 0
--
--       -- light モード
--       vim.o.background = "light"
--
--       vim.cmd("colorscheme everforest")
--     end,
--   },
-- }






-- return {
--   'projekt0n/github-nvim-theme',
--   name = 'github-theme',
--   lazy = false, -- make sure we load this during startup if it is your main colorscheme
--   priority = 1000, -- make sure to load this before all the other start plugins
--   config = function()
--     require('github-theme').setup({
--       -- ...
--     })
--
--     vim.cmd('colorscheme github_light')
--   end,
-- }
--

-- return {
--   {
--     "EdenEast/nightfox.nvim",
--     lazy = false,          -- 起動時に読み込む
--     priority = 1000,       -- colorscheme は最初に読み込む
--     config = function()
--       -- Nightfox の設定
--       require("nightfox").setup({
--         options = {
--           -- 必要ならここで透明化やスタイル設定もできる
--           -- transparent = true,
--         },
--       })
--
--       vim.cmd("colorscheme dawnfox")
--
--     end,
--   },
-- }


