local function switch_source_header(bufnr)
  local method_name = 'textDocument/switchSourceHeader'
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = 'clangd' })[1]
  if not client then
    return vim.notify(('method %s is not supported by any servers active on the current buffer'):format(method_name))
  end
  local params = vim.lsp.util.make_text_document_params(bufnr)
  client.request(method_name, params, function(err, result)
    if err then
      error(tostring(err))
    end
    if not result then
      vim.notify('corresponding file cannot be determined')
      return
    end
    vim.cmd.edit(vim.uri_to_fname(result))
  end, bufnr)
end

local function symbol_info()
  local bufnr = vim.api.nvim_get_current_buf()
  local clangd_client = vim.lsp.get_clients({ bufnr = bufnr, name = 'clangd' })[1]
  if not clangd_client or not clangd_client.supports_method 'textDocument/symbolInfo' then
    return vim.notify('Clangd client not found', vim.log.levels.ERROR)
  end
  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, clangd_client.offset_encoding)
  clangd_client.request('textDocument/symbolInfo', params, function(err, res)
    if err or #res == 0 then
      -- Clangd always returns an error, there is not reason to parse it
      return
    end
    local container = string.format('container: %s', res[1].containerName) ---@type string
    local name = string.format('name: %s', res[1].name) ---@type string
    vim.lsp.util.open_floating_preview({ name, container }, '', {
      height = 2,
      width = math.max(string.len(name), string.len(container)),
      focusable = false,
      focus = false,
      border = 'single',
      title = 'Symbol Info',
    })
  end, bufnr)
end


return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason-org/mason.nvim"
            -- "hrsh7th/nvim-cmp"
        },
        config = function()
            -- Add cmp_nvim_lsp capabilities
            local lspconfig_defaults = require('lspconfig').util.default_config
            lspconfig_defaults.capabilities = vim.tbl_deep_extend(
                'force',
                lspconfig_defaults.capabilities,
                require("blink.cmp").get_lsp_capabilities()
            )

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(ev)
                    -- buffer local mappings
                    local opts = { buffer = ev.buf, silent = true }

                    -- set binds
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
                    vim.keymap.set({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end, opts)
                    vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                end,
            })

            vim.diagnostic.config({
                virtual_text = true,
            })

            -- clangd specific
            vim.lsp.config("clangd", {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy"
                },
                on_attach = function(_, bufnr)
                    vim.api.nvim_buf_create_user_command(0, 'LspClangdSwitchSourceHeader', function()
                        switch_source_header(0)
                    end, { desc = 'Switch between source/header' })

                    vim.api.nvim_buf_create_user_command(0, 'LspClangdShowSymbolInfo', function()
                        symbol_info()
                    end, { desc = 'Show symbol info' })

                    local opts = { buffer = bufnr, silent = true }
                    vim.keymap.set('n', 'gh', '<cmd>LspClangdSwitchSourceHeader<CR>', opts)
                end,
            })
        end,
    },
   -- {
   --     "hrsh7th/cmp-nvim-lsp",
   -- },
   -- {
   --     "hrsh7th/nvim-cmp",
   --     config = function()
   --         local cmp = require('cmp')

   --         cmp.setup({
   --             sources = {
   --                 { name = 'nvim_lsp' },
   --             },
   --             mapping = cmp.mapping.preset.insert({
   --                 -- Navigate between completion items
   --                 ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
   --                 ['<C-n>'] = cmp.mapping.select_next_item({ behavior = 'select' }),

   --                 -- `Enter` key to confirm completion
   --                 ['<CR>'] = cmp.mapping.confirm({ select = false }),

   --                 -- Ctrl+Space to trigger completion menu
   --                 ['<C-Space>'] = cmp.mapping.complete(),

   --                 -- Scroll up and down in the completion documentation
   --                 ['<C-u>'] = cmp.mapping.scroll_docs(-4),
   --                 ['<C-d>'] = cmp.mapping.scroll_docs(4),
   --             }),
   --             snippet = {
   --                 expand = function(args)
   --                     vim.snippet.expand(args.body)
   --                 end,
   --             },
   --         })
   --     end
   -- },
}
