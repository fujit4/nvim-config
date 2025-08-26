-- 事前設定
vim.g.mapleader = ' '
vim.o.number = true
vim.o.syntax = 'on'
vim.o.signcolumn = 'yes'
vim.o.encoding = 'utf-8'
vim.o.fileencoding = 'utf-8'
vim.o.fileencodings = 'utf-8,sjis,euc-jp'
vim.o.bomb = false
vim.o.tabstop = 4       -- 画面上のTab幅（見た目）
vim.o.shiftwidth = 4    -- 自動インデント時の幅
vim.o.swapfile = false
vim.o.ambiwidth = 'single'
vim.opt.whichwrap:append("<,>,h,l,[,]")
vim.o.wrap = true          -- 折り返しを有効化
vim.o.linebreak = true     -- 単語の途中で折り返さない
vim.o.breakindent = true   -- 折り返し行でインデントを維持
vim.o.showbreak = "> "     -- 折り返し行の頭にマークを表示（お好みで）
vim.o.guifont = 'PlemolJP HSNF:h12'



-- 環境変数から `XDG_CONFIG_HOME` を取得して `runtimepath` に lazy.nvim を追加
local config_home = vim.env.XDG_CONFIG_HOME or vim.fn.stdpath('config')
vim.opt.rtp:prepend(config_home .. '/nvim/lazy/lazy.nvim')

-- -- lazy.nvim 読み込み
require('lazy').setup('plugins')

-- 挿入モードに入ったとき IME をオフにする
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    -- zenhan.exe を呼び出す（非同期で実行）
    vim.fn.jobstart({ "zenhan.exe", "0" })  -- "0" が IME OFF
  end,
})

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

vim.api.nvim_set_keymap("v", "<C-c>", '"+y', { noremap = true, silent = true })

--
vim.keymap.set("n", "<C-s>", ":w<CR>", {noremap = true, silent = true })

-- ctrl sでカーソル位置を保ったまま、ファイル保存
vim.keymap.set("i", "<C-s>", function()
  -- 現在のカーソル位置を記憶
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  -- 保存コマンドを実行
  vim.cmd("write")

  -- 以前のカーソル位置に戻す
  vim.api.nvim_win_set_cursor(0, cursor_pos)

end, { noremap = true, silent = true, desc = "Save without leaving insert mode" })

-- フォントサイズを増減するユーティリティ
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
  if new_size < 6 then new_size = 6 end  -- 下限を適当にガード

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


if vim.g.goneovim then
	-- 太字禁止設定
	vim.api.nvim_set_hl(0, "Bold", { bold = false })

	-- 全ハイライトから bold を除去
	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = function()
			for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
				local hl = vim.api.nvim_get_hl(0, { name = group })
				if hl.bold then
					hl.bold = false
					vim.api.nvim_set_hl(0, group, hl)
				end
			end
		end,
	})
end

