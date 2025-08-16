-- lua/plugins/colorscheme.lua
--
return {

	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "latte", -- ここで'latte'を指定
				background = { -- Optional – Set a custom background.
					light = "latte",
					dark = "latte",
				},
				-- その他の設定
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	}
}
--
-- return {
-- 	{
-- 		"sainnhe/gruvbox-material",
-- 		priority = 1000,
-- 		config = function()
-- 			vim.g.gruvbox_material_background = "light"
-- 			vim.g.gruvbox_material_foreground = "mix"
-- 			vim.g.gruvbox_material_enable_bold = 1
-- 			vim.g.gruvbox_material_ui_contrast = "high"
-- 			vim.g.gruvbox_material_disable_italic_comment = 1
-- 			vim.o.background = "light"
-- 			vim.cmd("colorscheme gruvbox-material")
-- 		end,
-- 	},
-- }
