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
vim.o.ambiwidth = 'double'
vim.opt.whichwrap:append("<,>,h,l,[,]")
vim.o.wrap = true        -- 折り返しを有効化
vim.o.linebreak = true   -- 単語の途中で折り返さない
vim.o.breakindent = true -- 折り返し行でインデントを維持
-- vim.o.showbreak = "> "   -- 折り返し行の頭にマークを表示
vim.o.guifont = 'PlemolJP HSNF:h12'
vim.o.timeout = false -- モードのタイムアウトを無効にする

-- カラースキーマの設定
vim.cmd[[colorscheme morning]]

-- LSP周りの設定 ------------------------------------------------------

-- キーマップ
local lsp_maps = {
  -- 移動
  { "n", "gd", "definition", vim.lsp.buf.definition },
  { "n", "gD", "declaration", vim.lsp.buf.declaration },
  { "n", "gi", "implementation", vim.lsp.buf.implementation },
  { "n", "gr", "references", vim.lsp.buf.references },

  -- 情報
  { "n", "<C-k>", "hover", vim.lsp.buf.hover },
  { "n", "<leader>sh", "signature help", vim.lsp.buf.signature_help },

  -- 編集
  { "n", "<leader>rn", "rename", vim.lsp.buf.rename },
  { "n", "<leader>ca", "code action", vim.lsp.buf.code_action },

  -- 診断
  { "n", "[d", "prev diagnostic", vim.diagnostic.goto_prev },
  { "n", "]d", "next diagnostic", vim.diagnostic.goto_next },
  { "n", "<leader>e", "diagnostic detail", vim.diagnostic.open_float },
}

-- キーマップの適用
local function apply_lsp_keymaps(bufnr)
  for _, m in ipairs(lsp_maps) do
    local mode, lhs, _, rhs = unpack(m)
    vim.keymap.set(mode, lhs, rhs, {
      buffer = bufnr,
      silent = true,
    })
  end
end

-- キーマップのヘルプ
local function show_lsp_help()
  local lines = { "LSP keymaps", "-----------" }

  for _, m in ipairs(lsp_maps) do
    local mode, lhs, desc = m[1], m[2], m[3]
    table.insert(lines, string.format("%-10s %s", lhs, desc))
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>lh", show_lsp_help)


-- LSPクライアント本体

-- Go (gopls)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.lsp.start({
      name = "gopls",
      cmd = { "gopls" },
      root_dir = vim.fn.getcwd(),
    })

	apply_lsp_keymaps(vim.api.nvim_get_current_buf())
  end,
})

-- Lua (lua-language-server)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.lsp.start({
      name = "lua_ls",
      cmd = { "lua-language-server" },
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })

	apply_lsp_keymaps(vim.api.nvim_get_current_buf())
  end,
})


-- 入力補完
vim.opt.completeopt = { "menu", "menuone", "noselect" }

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

