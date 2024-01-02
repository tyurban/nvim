return {
  'williamboman/mason.nvim',
  lazy = true,
  opts = { install_root_dir = os.getenv('NVIM_ROOT') .. '/mason' },
}
