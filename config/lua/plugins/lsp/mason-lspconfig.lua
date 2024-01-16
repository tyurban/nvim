return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    'williamboman/mason.nvim',
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    { 'folke/neodev.nvim', opts={} },
    'mfussenegger/nvim-jdtls',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('mason-lspconfig').setup {
      ensure_installed = { 'jdtls' },
      automatic_installation = true,
    }

    vim.cmd([[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]])
    vim.cmd([[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]])

    local border = {
      {'🭽', 'FloatBorder'},
      {'▔', 'FloatBorder'},
      {'🭾', 'FloatBorder'},
      {'▕', 'FloatBorder'},
      {'🭿', 'FloatBorder'},
      {'▁', 'FloatBorder'},
      {'🭼', 'FloatBorder'},
      {'▏', 'FloatBorder'},
    }

    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or border
      return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end

    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    for _, server in ipairs({ 'gopls', 'pyright' }) do
      require('lspconfig')[server].setup({ capabilities = capabilities })
    end

    require('lspconfig').lua_ls.setup({
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
        vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', { buffer = ev.buf, desc = "Goto the definition of the word under the cursor, if there's only one, otherwise show all options in Telescope." })
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, desc = 'Displays hover information about the symbol under the cursor in a floating window. Calling the function twice will jump into the floating window.' })
        vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', { buffer = ev.buf, desc = "Goto the implementation of the word under the cursor if there's only one, otherwise show all options in Telescope." })
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = ev.buf, desc = 'Displays signature information about the symbol under the cursor in a floating window.' })
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, { buffer = ev.buf, desc = 'Add the folder at path to the workspace folders. If {path} is not provided, the user will be prompted for a path using input().' })
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, { buffer = ev.buf, desc = 'Remove the folder at path from the workspace folders. If {path} is not provided, the user will be prompted for a path using input().' })
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, { buffer = ev.buf, desc = 'List workspace folders.' })
        vim.keymap.set('n', '<space>D', '<cmd>Telescope diagnostics bufnr=0<CR>', { buffer = ev.buf, desc = 'Lists Diagnostics for the current buffer.' })
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, { buffer = ev.buf, desc = 'Renames all references to the symbol under the cursor.' })
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, { buffer = ev.buf, desc = 'Selects a code action available at the current cursor position.' })
        vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references', { buffer = ev.buf, desc = 'Lists LSP references for word under the cursor.' })
        vim.keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definitions', { buffer = ev.buf, desc = "Goto the definition of the type of the word under the cursor, if there's only one, otherwise show all options in Telescope." })
      end,
    })

  end,
}
