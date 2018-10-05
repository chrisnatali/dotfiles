" cjn's vimrc


" Use Vim settings, rather then Vi settings
" This must be first, because it changes other options as a side effect.
set nocompatible

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" install Vundle bundles
" see https://github.com/VundleVim/Vundle.vim for doc
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

call vundle#end()

syntax on
filetype indent plugin on

set omnifunc=syntaxcomplete#Complete

" Default tab/shift spacing
set expandtab           " enter spaces when tab is pressed
set tabstop=2           " use 4 spaces to represent tab
set softtabstop=2
set shiftwidth=2        " number of spaces to use for auto indent
" set autoindent          " copy indent from current line when starting a new line

autocmd FileType ruby setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4
