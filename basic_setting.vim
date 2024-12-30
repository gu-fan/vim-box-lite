" Basic Vim Configuration
"
" General Settings
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,utf-16,gbk,big5,gb18030,latin1
set fileformat=unix
scriptencoding utf-8
language messages en_US.utf-8

set nrformats-=octal

set mmp=100000
set bo=all

se imdisable
se imsearch=1
se noimcmdline

set suffixesadd+=.js,.css,.html,.vim,.vue,.gd,.py
set ttimeoutlen=0
set path+=/usr/local/bin,/home/ryk/bin

if has('nvim')
    set clipboard+=unnamedplus
else
    if has('unnamedplus')
        set clipboard=autoselectplus,unnamedplus,exclude:cons\|linux
    else
        set clipboard=autoselect,unnamed
    endif
endif

set nocompatible
set hidden
set autoread
set backspace=indent,eol,start
set virtualedit=block
set history=1000

" Indentation and Tabs
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase
set nowrapscan

nnoremap   <silent>   <C-L>   :let @/=''\|redraw!<CR>

" UI
set nonumber
set norelativenumber
set cursorline
set showmatch
set wildmenu
set wildmode=list:longest,full
set laststatus=2
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

set scrolloff=1
set sidescroll=1
set sidescrolloff=2
set display+=lastline

" Folding
set foldmethod=syntax
set foldcolumn=0
set foldlevel=0 
set foldlevelstart=1
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
set foldclose=

function! ToggleNumber()
    if &relativenumber == 1
        set norelativenumber
        set number
    elseif &number == 1
        set nonumber
    else
        set relativenumber
    endif
endfunc

nnoremap <leader>nn :call ToggleNumber()<CR>

" Backups and Undo
set backup
if has('nvim')
    set backupdir=~/.vim/ntmp/backup//
    set directory=~/.vim/ntmp/swap//
    set undodir=~/.vim/ntmp/undo//
    set shada='50,<1000,s100,:100,n~/.vim/ntmp/shada
    silent! call mkdir(expand('~/.vim/ntmp/backup'), 'p')
    silent! call mkdir(expand('~/.vim/ntmp/swap'), 'p')
    silent! call mkdir(expand('~/.vim/ntmp/undo'), 'p')
else
    set backupdir=$HOME/.vim/tmp/backup//
    set directory=$HOME/.vim/tmp/swap//
    set undodir=$HOME/.vim/tmp/undo//
    set viminfo='50,<1000,s100,:100,n$HOME/.vim/tmp/viminfo
    silent! call mkdir(expand('~/.vim/tmp/backup'), 'p')
    silent! call mkdir(expand('~/.vim/tmp/swap'), 'p')
    silent! call mkdir(expand('~/.vim/tmp/undo'), 'p')
endif
set undofile
set undoreload=1000
set noswapfile

set sessionoptions-=options
set viewoptions-=options
