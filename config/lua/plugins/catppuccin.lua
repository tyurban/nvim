return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  config = function()
    local colors = require('catppuccin.palettes').get_palette()
    colors.none = 'NONE'

    require('catppuccin').setup({
      transparent_background = true,
      term_colors = true,
      styles =  {
        keywords = { 'bold' },
        functions = { 'italic' },
      },
      integrations = {
        mason = true,
      },
    })

    vim.cmd.colorscheme('catppuccin')
  end,
}
