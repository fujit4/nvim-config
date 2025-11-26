return {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" }, -- vimグローバルを未定義扱いしない
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
				checkThirdParty = false,
			},
			completion = {
				callSnippet = "Replace",
			},
		},
	}
}
