return {
  "L3MON4D3/LuaSnip",
  -- follow latest release.
  version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  -- install jsregexp (optional!).
  build = "make install_jsregexp",

  config = function()
    local ls = require("luasnip")
    require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/luasnippets" })

    ls.setup({ enable_autosnippets = true })

    -- Tab to expand or jump forward
    vim.keymap.set({ "i", "s" }, "<Tab>", function()
      if ls.expand_or_jumpable() then
        return "<Plug>luasnip-expand-or-jump"
      else
        return "<Tab>" -- Normal tab if no snippet
      end
    end, { expr = true, silent = true })

    -- Shift-Tab to jump backward
    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
      if ls.jumpable(-1) then
        return "<Plug>luasnip-jump-prev"
      else
        return "<S-Tab>" -- Normal shift-tab if can't jump
      end
    end, { expr = true, silent = true })

    vim.keymap.set({ "i", "s" }, "<Plug>luasnip-expand-or-jump", function()
      ls.expand_or_jump()
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<Plug>luasnip-jump-prev", function()
      ls.jump(-1)
    end, { silent = true })
  end
}
