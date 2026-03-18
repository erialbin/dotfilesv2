local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "cpp", "python", "c", "lua", "vim",
        "vimdoc", "query", "markdown", "markdown_inline",
      },
      auto_install = true,
      ignore_install = { "javascript", "latex" },
      highlight = { enable = true },
    })
  end,
}
return { M }
