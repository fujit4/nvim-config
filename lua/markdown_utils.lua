-- lua/markdown_utils.lua
local M = {}

-- 現在行のインデントを返す
local function get_indent(line)
  return line:match("^(%s*)") or ""
end

-- 1行処理: リスト項目をトグル
local function process_toggle_list(line)
  if line:match("^%s*%- ") then
    return (line:gsub("^(%s*)%- ", "%1"))
  else
    local indent = get_indent(line)
    return indent .. "- " .. line:gsub("^%s*", "")
  end
end

-- 1行処理: チェックボックスの存在をトグル
local function process_toggle_checkbox_presence(line)
  if line:match("^%s*%- %[[ x]%] ") then
    return (line:gsub("^(%s*)%- %[[ x]%] ", "%1"))
  else
    local indent = get_indent(line)
    return indent .. "- [ ] " .. line:gsub("^%s*", "")
  end
end

-- 1行処理: チェックボックスの状態を完了状態に
local function process_check_checkbox(line)
  if line:match("^%s*%- %[ %]") then
    return (line:gsub("^(%s*%-) %[ %]", "%1 [x]"))
  elseif line:match("^%s*%- %[x%]") then
    return line
  else
    local indent = get_indent(line)
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
function M.toggle_list(stay_insert) apply_to_lines(process_toggle_list, stay_insert) end
function M.toggle_checkbox_presence(stay_insert) apply_to_lines(process_toggle_checkbox_presence, stay_insert) end
function M.toggle_checkbox_state(stay_insert) apply_to_lines(process_check_checkbox, stay_insert) end

-- キーマッピング（Markdown 専用）
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- ノーマル / ビジュアル
    vim.keymap.set({"n", "v"}, "<C-S-b>", function() M.toggle_list(false) end, { buffer = true, desc = "Toggle list item" })
    vim.keymap.set({"n", "v"}, "<C-S-c>", function() M.toggle_checkbox_presence(false) end, { buffer = true, desc = "Toggle checkbox" })
    vim.keymap.set({"n", "v"}, "<C-S-x>", function() M.toggle_checkbox_state(false) end, { buffer = true, desc = "Toggle checkbox state" })
    -- インサートモード
    vim.keymap.set("i", "<C-S-b>", function() M.toggle_list(true) end, { buffer = true, desc = "Toggle list item (insert)" })
    vim.keymap.set("i", "<C-S-c>", function() M.toggle_checkbox_presence(true) end, { buffer = true, desc = "Toggle checkbox (insert)" })
    vim.keymap.set("i", "<C-S-x>", function() M.toggle_checkbox_state(true) end, { buffer = true, desc = "Toggle checkbox state (insert)" })
  end,
})

return M
