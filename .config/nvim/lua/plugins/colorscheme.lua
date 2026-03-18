return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",

        on_highlights = function(hl, colors)
          hl.LineNr = {
            fg = colors.orange
          }
          hl.CursorLineNr = {
            fg = colors.orange
          }
        end
      })
      vim.cmd([[colorscheme tokyonight-night]])
    end
  }
}
