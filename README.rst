Vimrc lite
===========

My personal vimrc file

Install
-------

1. download and put it somewhere::

    git clone https://github.com/gu-fan/vim-box-lite.git ~/vim/vim-box-lite

2. install vim-plug, see details in
   https://github.com/junegunn/vim-plug::

    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

3. edit vimrc `~/.vimrc`::

    cd ~/vim/vim-box-lite
    so ~/vim/vim-box-lite/index.vim

4. Plug Install::

    :PlugInstall

5. Done!

Hints
-----

basic settings: basic.vim
    settings, commands and mappings
packages: plugin.vim
ui settings: ui.vim
    if missing fonts, see ui.vim and download the font

works in windows/linux/macOS
