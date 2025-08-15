-- lua/plugins/colorscheme.lua

return {
	{
		"sainnhe/gruvbox-material",
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_background = "light"
			vim.g.gruvbox_material_foreground = "mix"
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
--     "ellisonleao/gruvbox.nvim",
--     priority = 1000,
--     config = function()
--       require("gruvbox").setup({
--         contrast = "hard",
--         transparent_mode = false,
--       })
--       vim.o.background = "light"
--       vim.cmd("colorscheme gruvbox")
--     end
--   }
-- }
