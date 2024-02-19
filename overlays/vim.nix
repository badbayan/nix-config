_: prev: {
  vim-with-vimrc = prev.vim.customize {
    vimrcConfig.beforePlugins = builtins.readFile ./vim/vimrc;
  };
}
