return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    'williamboman/mason.nvim',
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    { 'folke/neodev.nvim', opts={} },
    'mfussenegger/nvim-jdtls',
  },
  lazy = true,
  config = function()
    require('mason-lspconfig').setup {
      ensure_installed = { 'jdtls' },
      automatic_installation = true,
    }

    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    for _, server in ipairs({ 'gopls', 'pyright' }) do
      require('lspconfig')[server].setup({ capabilities = capabilities })
    end

    require'lspconfig'.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
        },
      },
      on_init = function(client)
        local path = client.workspace_folders[1].name

        if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
          client.config.settings = vim.tbl_deep_extend(
            'force',
            client.config.settings,
            {
              Lua = {
                diagnostics = {
                  globals = { 'vim' },
                },
                runtime = {
                  version = 'LuaJIT',
                },
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                  },
                },
              },
            }
          )

          client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
        end
        return true
      end,
    })

    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = 'Show diagnostics in a floating window.' })
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Move to the previous diagnostic in the current buffer.' })
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Move to the next diagnostic.' })
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = 'Add buffer diagnostics to the location list.' })

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = ev.buf, desc = 'Jumps to the declaration of the symbol under the cursor.' })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = 'Jumps to the definition of the symbol under the cursor.' })
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, desc = 'Displays hover information about the symbol under the cursor in a floating window. Calling the function twice will jump into the floating window.' })
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = ev.buf, desc = 'Lists all the implementations for the symbol under the cursor in the quickfix window.' })
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = ev.buf, desc = 'Displays signature information about the symbol under the cursor in a floating window.' })
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, { buffer = ev.buf, desc = 'Add the folder at path to the workspace folders. If {path} is not provided, the user will be prompted for a path using input().' })
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, { buffer = ev.buf, desc = 'Remove the folder at path from the workspace folders. If {path} is not provided, the user will be prompted for a path using input().' })
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, { buffer = ev.buf, desc = 'List workspace folders.' })
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, { buffer = ev.buf, desc = 'Jumps to the definition of the type of the symbol under the cursor.' })
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, { buffer = ev.buf, desc = 'Renames all references to the symbol under the cursor.' })
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, { buffer = ev.buf, desc = 'Selects a code action available at the current cursor position.' })
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf, desc = 'Lists all the references to the symbol under the cursor in the quickfix window.' })
        vim.keymap.set('n', '<space>f', function()
          vim.lsp.buf.format { async = true }
        end, { buffer = ev.buf, desc = 'Formats a buffer using the attached (and optionally filtered) language server clients.' })
      end,
    })
  end,
}
