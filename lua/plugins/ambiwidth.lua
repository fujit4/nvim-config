return {
  "rbtnn/vim-ambiwidth",
  init = function()
	  local add_list = {}
	  for code = 0x25b2, 0x25c4 do
		  local char = vim.fn.nr2char(code)
		  if vim.fn.char2nr(char) == code then
			  table.insert(add_list, { code, code, 2 })
		  end
	  end
	  for code = 0x25ce, 0x25ce do
		  local char = vim.fn.nr2char(code)
		  if vim.fn.char2nr(char) == code then
			  table.insert(add_list, { code, code, 2 })
		  end
	  end 
	  vim.g.ambiwidth_add_list = add_list
  end,
}
