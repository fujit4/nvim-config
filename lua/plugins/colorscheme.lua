-- lua/plugins/colorscheme.lua

-- return {
--   'projekt0n/github-nvim-theme',
--   name = 'github-theme',
--   lazy = false, -- make sure we load this during startup if it is your main colorscheme
--   priority = 1000, -- make sure to load this before all the other start plugins
--   config = function()
--     require('github-theme').setup({
--       -- ...
--     })
--
--     vim.cmd('colorscheme github_light')
--   end,
-- }
--

return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false,          -- 起動時に読み込む
    priority = 1000,       -- colorscheme は最初に読み込む
    config = function()
      -- Nightfox の設定
      require("nightfox").setup({
        options = {
          -- 必要ならここで透明化やスタイル設定もできる
          -- transparent = true,
        },
      })

      vim.cmd("colorscheme dawnfox")
    end,
  },
}


