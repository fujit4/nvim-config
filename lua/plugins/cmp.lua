return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter", -- 挿入モードで読み込み
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- LSP補完
    "hrsh7th/cmp-buffer",   -- バッファ内補完
    "hrsh7th/cmp-path",     -- パス補完
    "hrsh7th/cmp-cmdline",  -- コマンドライン補完
    "L3MON4D3/LuaSnip",     -- スニペットエンジン
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
				cmp.confirm({ select = false })  -- ←ここが重要
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

  end,
}

