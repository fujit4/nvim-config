return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- アイコン不要なら削除可
  config = function()
    require("lualine").setup({
      options = {
        theme = "gruvbox-material",
        icons_enabled = false,  -- リガチャ・アイコン不要のため
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        globalstatus = true,  -- ウィンドウごとのステータスラインではなく全体に
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { { "filename", path = 1 } }, -- 相対パス表示
        lualine_x = { "filetype", "encoding", "fileformat" },
        lualine_y = { "location" },
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}

