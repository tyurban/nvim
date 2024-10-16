return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.api.nvim_create_autocmd(
      "LspAttach",
      {
        callback = function(event)
          local bufmap = function(mode, lhs, rhs, desc)
            local opts = { buffer = event.buf, desc = desc }
            vim.keymap.set(mode, lhs, rhs, opts)
          end

          bufmap("n", "gd", vim.lsp.buf.definition, "Jumps to the definition of the symbol under the cursor.")
          bufmap("n", "<space>q", vim.diagnostic.setloclist, "Add buffer diagnostics to the location list.")
          bufmap("n", "<space>rn", vim.lsp.buf.rename, "Renames all references to the symbol under the cursor.")
        end
      }
    )

    vim.diagnostic.config({
      virtual_text = {
        source = true,
      }
    })

    local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
  end,
}
