return {
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
}
