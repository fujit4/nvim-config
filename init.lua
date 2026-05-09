vim.g.mapleader = ' '

vim.o.number = true
vim.o.syntax = 'on'
vim.o.signcolumn = 'yes'

vim.o.encoding = 'utf-8'
vim.o.fileencoding = 'utf-8'
vim.o.fileencodings = 'utf-8,sjis,euc-jp'
vim.o.bomb = false

vim.o.tabstop = 4    -- 画面上のTab幅（見た目）
vim.o.shiftwidth = 4 -- 自動インデント時の幅

vim.o.swapfile = false

vim.o.ambiwidth = 'single'
vim.opt.whichwrap:append("<,>,h,l,[,]")

vim.o.wrap = true        -- 折り返しを有効化
vim.o.linebreak = true   -- 単語の途中で折り返さない
vim.o.breakindent = true -- 折り返し行でインデントを維持

vim.o.timeout = false    -- モードのタイムアウトを無効にする

vim.o.guifont = 'PlemolJP HSNF:h12'

vim.cmd [[colorscheme default]]

-- terminal -----------------------------------------------------------
-- 抜ける専用
vim.keymap.set('t', '<Esc><Esc><Esc>', [[<C-\><C-n>]])

-- 移動で暗黙的に抜ける
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]])
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]])
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]])
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]])


-- IME周りの設定 ------------------------------------------------------
-- 挿入モードに入ったとき IME をオフにする
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		-- zenhan.exe を呼び出す（非同期で実行）
		vim.fn.jobstart({ "zenhan.exe", "0" }) -- "0" が IME OFF
	end,
})

-- Windows風に使うための設定（コピペ、保存） ------------------------------------------------------
-- ctrl v でpasteモードにして貼り付けてnopasteに戻す
vim.keymap.set("i", "<C-v>", function()
	-- pasteモードを一時的に有効にする
	vim.cmd("set paste")
	-- クリップボードから貼り付け
	vim.api.nvim_feedkeys(vim.fn.getreg("+"), "n", true)
	-- pasteモードを無効に戻す
	vim.defer_fn(function()
		vim.cmd("set nopaste")
	end, 0)
end, { noremap = true, silent = true })

vim.keymap.set("c", "<C-v>", "<C-r>+", { noremap = true })

vim.api.nvim_set_keymap("v", "<C-c>", '"+y', { noremap = true, silent = true })

--
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })

-- ctrl sでカーソル位置を保ったまま、ファイル保存
vim.keymap.set("i", "<C-s>", function()
	-- 現在のカーソル位置を記憶
	local cursor_pos = vim.api.nvim_win_get_cursor(0)

	-- 保存コマンドを実行
	vim.cmd("write")

	-- 以前のカーソル位置に戻す
	vim.api.nvim_win_set_cursor(0, cursor_pos)
end, { noremap = true, silent = true, desc = "Save without leaving insert mode" })

-- フォントサイズを増減するユーティリティ ---------------------------------
local function font_size_change(delta)
	local guifont = vim.o.guifont
	if guifont == nil or guifont == "" then
		print 'not defined default "guifont" setting'
		return
	end

	-- 例: "PlemolJP Console NF:h12,b" のような表記を想定
	local name, size, tail = guifont:match("^(.-):h(%d+%.?%d*)(.*)$")
	if not name then
		-- サイズ指定がない場合は :h12 を仮定
		name, size, tail = guifont, "12", ""
	end

	local new_size = tonumber(size) + delta
	if new_size < 6 then new_size = 6 end -- 下限を適当にガード

	vim.o.guifont = string.format("%s:h%s%s", name, new_size, tail or "")
end

vim.api.nvim_create_user_command("FontSizeUp", function()
	font_size_change(1)
end, {})

vim.api.nvim_create_user_command("FontSizeDown", function()
	font_size_change(-1)
end, {})


-- Ctrl + でフォントサイズを +1
vim.keymap.set({ "n", "i", "v", "c" }, "<C-S-;>", function()
	font_size_change(1)
end, { desc = "Increase GUI font size by 1pt", silent = true })

-- Ctrl - で -1
vim.keymap.set({ "n", "i", "v", "c" }, "<C-->", function()
	font_size_change(-1)
end, { desc = "Decrease GUI font size by 1pt", silent = true })


-- マークダウン操作 ---------------------------------------------------
require("markdown_utils")

-- plugins ------------------------------------------------------------
vim.pack.add({
	{
		src = 'https://github.com/stevearc/oil.nvim',
		version = 'v2.15.0',
	},
	{
		src = 'https://github.com/rbtnn/vim-ambiwidth',
		version = '4fd0579',
	},
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
})

require("oil").setup()


ambiwidth_add_list = function()
	local add_list = {}
	-- ▲(Triangles) to ◄(Geometric Shapes)
	for code = 0x25b2, 0x25c4 do
		local char = vim.fn.nr2char(code)
		if vim.fn.char2nr(char) == code then
			table.insert(add_list, { code, code, 2 })
		end
	end
	-- ◎(BULLSEYE) 
	table.insert(add_list, { 0x25ce, 0x25ce, 2 })
	-- ×(かける）
	table.insert(add_list, { 0x00d7, 0x00d7, 2 })
	-- ÷(わる)
	table.insert(add_list, { 0x00f7, 0x00f7, 2 })

	vim.g.ambiwidth_add_list = add_list

end

ambiwidth_add_list()


-- LSP周りの設定 ------------------------------------------------------

vim.lsp.enable("lua_ls")
vim.lsp.enable("gopls")

vim.keymap.set("n", "grd", vim.diagnostic.open_float)

-- 入力補完
vim.opt.completeopt = { "menu", "menuone", "noselect","popup" }
vim.o.pumborder = "single"

-- Tab操作で選択肢を移動
vim.keymap.set("i", "<Tab>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-n>"
	end
	return "<Tab>"
end, { expr = true })

vim.keymap.set("i", "<S-Tab>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-p>"
	end
	return "<S-Tab>"
end, { expr = true })

-- Enterで確定
vim.keymap.set("i", "<CR>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-y>"
	end
	return "<CR>"
end, { expr = true })

