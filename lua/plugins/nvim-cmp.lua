local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "garymjr/nvim-snippets",
    "hrsh7th/cmp-nvim-lsp-signature-help",
  },
  opts = function()
    local cmp = require("cmp")
    return {
      snippet = {
	expand = function(args)
	  vim.snippet.expand(args.body)
	end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = function(fallback)
          if not cmp.select_next_item() then
            if vim.bo.buftype ~= 'prompt' and has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end
        end,
        ['<S-Tab>'] = function(fallback)
          if not cmp.select_prev_item() then
            if vim.bo.buftype ~= 'prompt' and has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end
        end,
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
	{ name = "nvim_lsp_signature_help" },
	{ name = "snippets" },
        { name = "buffer" },
      })
    }
  end,
}
