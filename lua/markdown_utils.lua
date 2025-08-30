-- lua/markdown_utils.lua
local M = {}

-- 現在行のインデントを返す
local function get_indent(line)
  return line:match("^(%s*)") or ""
end

-- 1行処理: リスト追加
local function process_add_list(line)
  local indent = get_indent(line)
  if not line:match("^%s*%-") then
    return indent .. "- " .. line:gsub("^%s*", "")
  end
  return line
end

-- 1行処理: チェックボックス追加
local function process_add_checkbox(line)
  local indent = get_indent(line)
  if not line:match("^%s*%- %[.%]") then
    return indent .. "- [ ] " .. line:gsub("^%s*", "")
  end
  return line
end

-- 1行処理: チェックボックストグル
local function process_toggle_checkbox(line)
  local indent = get_indent(line)
  if line:match("^%s*%- %[ %]") then
    return (line:gsub("^(%s*%-) %[ %]", "%1 [x]"))
  elseif line:match("^%s*%- %[x%]") then
    return (line:gsub("^(%s*%-) %[x%]", "%1 [ ]"))
  else
    return indent .. "- [ ] " .. line:gsub("^%s*", "")
  end
end

-- 複数行に対して関数適用
local function apply_to_lines(func, stay_insert)
  local mode = vim.fn.mode()
  local start_line, end_line

  if mode == "v" or mode == "V" or mode == "" then
    start_line = vim.fn.getpos("'<")[2]
    end_line   = vim.fn.getpos("'>")[2]
  else
    start_line = vim.fn.line(".")
    end_line   = start_line
  end

  for lnum = start_line, end_line do
    local line = vim.fn.getline(lnum)
    vim.fn.setline(lnum, func(line))
  end

  -- インサートモードなら戻る
  if stay_insert then
    vim.cmd("startinsert!")
  end
end

-- 公開関数
function M.add_list(stay_insert)        apply_to_lines(process_add_list, stay_insert) end
function M.add_checkbox(stay_insert)    apply_to_lines(process_add_checkbox, stay_insert) end
function M.toggle_checkbox(stay_insert) apply_to_lines(process_toggle_checkbox, stay_insert) end

-- キーマッピング（Markdown 専用）
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- ノーマル / ビジュアル
    vim.keymap.set({"n", "v"}, "<Leader>l", function() M.add_list(false) end, { buffer = true, desc = "Add list" })
    vim.keymap.set({"n", "v"}, "<Leader>c", function() M.add_checkbox(false) end, { buffer = true, desc = "Add checkbox" })
    vim.keymap.set({"n", "v"}, "<Leader>x", function() M.toggle_checkbox(false) end, { buffer = true, desc = "Toggle checkbox" })
    -- インサートモード
    vim.keymap.set("i", "<C-l>", function() M.add_list(true) end, { buffer = true, desc = "Add list (insert)" })
    vim.keymap.set("i", "<C-c>", function() M.add_checkbox(true) end, { buffer = true, desc = "Add checkbox (insert)" })
    vim.keymap.set("i", "<C-x>", function() M.toggle_checkbox(true) end, { buffer = true, desc = "Toggle checkbox (insert)" })
  end,
})

return M
