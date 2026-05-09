return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".git",
	},
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" }, -- vimグローバルを未定義扱いしない
			},
			runtime = {
				version = "LuaJIT",
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
