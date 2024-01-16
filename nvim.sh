base_path=$(dirname "$BASH_SOURCE")

export PATH=$base_path/cmake/bin:$base_path/ripgrep:$base_path/nvim-linux64/bin:$PATH
export NVIM_ROOT=$base_path

config_path=$HOME/.config/nvim
mkdir -p $config_path
ln -sf $base_path/config/* $config_path/
