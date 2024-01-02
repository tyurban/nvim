local lazy = os.getenv('NVIM_ROOT') .. '/lazy'
local lazypath = lazy .. '/lazy.nvim'

vim.opt.rtp:prepend(lazypath)

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end

require('lazy').setup({
  root = lazy,
  spec = {
    { import = 'plugins' },
    { import = 'plugins.lsp' },
  },
  install = {
    colorscheme = { 'catppuccin' },
  },
})
