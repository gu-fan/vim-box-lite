let galaxy_path = expand("~/.vim/plugged/galaxy.vim/colors/galaxy.vim")

" Theme
let g:galaxy_enable_statusline = 0

let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1

let g:airline_powerline_fonts=1
" let g:airline#extensions#hunks#non_zero_only = 1

let g:airline_theme='base16_grayscale'


let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ }


if !exists('s:ui_loaded')
    let s:ui_loaded = 1
    if filereadable(galaxy_path) 
        " exe "source " .galaxy_path
        " colorscheme galaxy
        " set t_Co=256                   " 256 colors for terminal
    else
        set background=dark            " set a dark background
        " colorscheme slate
        " colorscheme slate
    endif
    " set background=light
    set background=dark
    " colorscheme solarized8_low
    " colorscheme sialoquent
    " colorscheme tokyonight
    " colorscheme catppuccin_mocha
    " colorscheme spaceduck
    colorscheme deep-space


    if g:os.is_windows
        " set guifont=Droid\ Sans\ Mono\ for\ Powerline:h12
        " set guifont=Microsoft\ Yahei\ Mono:h14
        set guifont=Lucida\ console:h12
    elseif g:os.is_mac
        " echoe 'MAC FONT'
        set guifont=Droid\ Sans\ Mono\ for\ Powerline:h18
        " set guifontwide=兰亭黑-简\ 纤黑:h16
        " http://wenq.org/wqy2/index.cgi?Download#MicroHei_Beta
        " set guifontwide=文泉驿等宽微米黑:h16
    elseif g:os.is_unix
        " default in mint 20
        set guifont=DejaVu\ Sans\ Mono\ 16
        " sudo apt install ttf-wqy-microhei ttf-wqy-zenhei
        " set guifontwide=WenQuanYi\ Micro\ Hei\ Mono\:h16
    endif
    set lazyredraw                  " only redraws if it is needed

    set ls=2                        " status line always visible
    set go-=T                       " hide the toolbar
    set go-=m                       " hide the menu
    set go-=e                       " hide the gui tab
    " The next two lines are quite tricky, but in Gvim, if you don't do this, if you
    " only hide all the scrollbars, the vertical scrollbar is showed anyway
    set go+=rlRLbh                  " show all the scrollbars
    set go-=rlRLbh                  " hide all the scrollbars

    set hidden                      " hide the inactive buffers
    set ruler                       " sets a permanent rule
    set showcmd                     " shows partial commands

    set winheight=10
    set winminheight=0
    set noequalalways

    set splitright
    set splitbelow

    " set formatoptions=qrn1ct
    set textwidth=0
    " set cc=81
    set cc=

    " set scrolloff=7                 " buffer when scrolling
    set scrolloff=1 scrolljump=1
    " set cursorline                  " highlight the line under the cursor
    set fillchars+=vert:│           " better looking for windows separator


    " shell
    " if has('unix')
    "     set shell=/bin/sh
    " endif

    " set title                       " set the terminal title to the current file
    " set ttyfast                     " better screen redraw
    " set visualbell                  " turn on the visual bell

    " command line
    set wildmenu                        " Command line autocompletion
    " set wildmode=list:longest,full      " Shows all the options
    set wildmode=longest,full      " Shows all the options

    set wildignore+=*.sw?                            " Vim swap files
    set wildignore+=*.bak,*.?~,*.??~,*.???~,*.~      " Backup files
    set wildignore+=*.luac                           " Lua byte code
    set wildignore+=*.jar                            " java archives
    set wildignore+=*.pyc                            " Python byte code
    set wildignore+=*.stats                          " Pylint stats

    if g:os.is_windows
        wins 999 999
    elseif g:os.is_linux && !exists("g:_no_max")
        if !has('nvim')
            wins 80 65
        endif
        " winp 2500 0
        " augroup maximizewindow 
        "     autocmd! 
        "     autocmd VimEnter * call system('wmctrl -i -b add,maximized_vert,maximized_horz -r '.v:windowid)
        " augroup END
    endif

endif

