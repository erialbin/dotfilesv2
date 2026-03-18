return {
  "lervag/vimtex",
  lazy = false,     -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.cmd([[set conceallevel=0]])
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_quickfix_open_on_warning = 0
    vim.g.vimtex_complete_close_braces = 0

    vim.g.vimtex_compiler_latexmk = {
      options =  {
        "-pdf",
        "-pvc",
        "-synctex=1",
        "-file-line-error",
        "-halt-on-error",
        "-interaction=nonstopmode",
      },
    }
  end
}
