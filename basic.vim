so basic_setting.vim
so basic_mapping.vim

" terminal color
let g:terminal_ansi_colors = 
            \['#616161', '#f08978', '#c3f884', '#fefdc8', '#afd4fa', '#f295f7', '#d0d1fa', '#f1f1f1'
            \,'#8e8e8e', '#f7c6bf', '#ddfbc0', '#fefdd9', '#c8e2fc', '#f5b5f9', '#e5e6fc', '#fffeff']


" Commands
com! Copy let @+ = expand('%:p')|echo 'PATH:'.@+
com! Pwd let @+ = expand('%:p:h')|echo 'PATH:'.@+
com! Trail call Trim()
com! Trim call Trim()

" cabbrev ss so %
" cabbrev E e
" cabbrev dir Dir
" cabbrev trim Trim
" cabbrev copy Copy


function! Trim()
    sil! %s#\s\+$##g
    w!
endfun

" folding
" Mapping
" Folding
" set foldtext=MyFoldText()
" set foldenable 
" set foldmethod=marker "{{{

" }}}


" Backups {{{
" }}}
"
if g:os.is_windows || g:os.is_linux
    " ms win alike
    "
    source $VIMRUNTIME/mswin.vim

    " Undo/Redo, add 'zv' to view redo/undo line
    nor <C-Z>       uzv
    ino <C-Z>       <C-O>u<C-O>zv
    vno <C-Z>       <Nop>

    nor <C-S-Z>     <C-R>zv

    nor <C-Y>       <C-R>zv
    ino <C-Y>       <C-O><C-R><C-O>zv
    vno <C-Y>       <Nop>

    " CTRL-A is Select all: 
    " change select mode to visual mode,
    " except insert mode
    noremap <C-A> ggVG
    inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
    cnoremap <C-A> <C-C>ggVG
    onoremap <C-A> <C-C>ggVG
    snoremap <C-A> <C-C>ggVG
    xnoremap <C-A> <C-C>ggVG
    set selectmode = 
    noremap Y y$
    " noremap <C-Q> :q!<CR>

elseif g:os.is_mac
    nor <C-Y>       <C-R>zv
    ino <C-Y>       <C-O><C-R><C-O>zv
    vno <C-Y>       <Nop>
    noremap Y y$
endif

"
aug au_basic
  au!
    au BufEnter,BufNew,BufReadPost * silent! lcd %:p:h:gs/ /\\ /
    " au BufEnter,BufNew,BufReadPost * silent! exec 'setl sua+=.'.expand('<afile>:e')

    " to the line when file last opened
    au BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe  "normal! g`\"" | endif
    au CompleteDone * if pumvisible() == 0 | pclose | endif
    autocmd QuickFixCmdPost * botright copen 8

aug END

aug au_GuiEnter "{{{
    au!
    au GuiEnter * set t_vb=
aug END

aug au_Filetypes "{{{
    au!
    au BufRead,BufNewFile *.j,*.wct setf jass
    au BufRead,BufNewFile *.wxs setf javascript
    au BufRead,BufNewFile *.mako    setf mako
    au BufRead,BufNewFile *.conf    setf conf
    au BufRead,BufNewFile tmux.conf setf tmux
    au BufRead,BufNewFile *.hbs setf mustache
    au FileType c,cpp    setl fdm=syntax
    au BufRead,BufNewFile *.dart set sw=2 tabstop=2 softtabstop=2 expandtab autoindent
    au FileType dart set sw=2 tabstop=2 softtabstop=2 expandtab autoindent
    au FileType jass     setl wrap fdm=syntax
    au FileType jass     nor <buffer> gD :call <SID>jass_goDef()<CR>
    au FileType javascript call <SID>js_fold()
    au FileType javascript,typescript setl sw=4
    au FileType python map <buffer> <F1> :Pydoc <C-R><C-W><CR>
    au FileType python map <buffer> K k
    au FileType python setl wrap foldtext=MyFoldText()
    au BufRead,BufNewFile *.edge setf html
    " au FileType python  call <SID>py_aug()
    au FileType python  setl fdm=indent
    " au FileType javascript setl fdm=syntax
    au Filetype php,html,xhtml,xml setl shiftwidth=4 softtabstop=4
    au Filetype php,html,xhtml,xml setl foldmethod=indent
    au Filetype php setl smartindent
    au Filetype php cal <SID>check_html()
    au BufRead,BufNewFile *template*.php    setf conf
    au FileType help setl isk+=-,:
    au FileType help call <SID>hlp_fold()
    au FileType vim setl isk+=:
    au FileType html cal <SID>check_ft()
    " au FileType rst syn spell toplevel
    "
    au FileType cs setl fdm=syntax
    autocmd! BufWritePost *.dart call <SID>reload_dart()
    au FileType rst setl fdls=2
    au FileType rst setl fdl=2

    " CTRL P SET PATH
    " au FileType javascript cal <SID>set_path()

   " au BufWinEnter * if &buftype == 'terminal' | setlocal winfixheight | endif

aug END "}}}
function! s:reload_dart() abort
    if &shell =~? 'fish'
        sil execute '!kill -SIGUSR1 (pgrep -f "[f]lutter_tool.*run")'
    else
        sil execute '!kill -SIGUSR1 $(pgrep -f "[f]lutter_tool.*run")'
    endif
endfunction


aug au_Filetypes_gd "{{{
    au!
    au FileType gdscript setl fdm=expr
    au FileType gdscript setl fdls=1
    au Filetype gdscript setl shiftwidth=4 expandtab tabstop=4 softtabstop=4
    au BufRead,BufNewFile *.gd setl shiftwidth=4 expandtab tabstop=4 softtabstop=4
	" au FileType gdscript setl foldexpr=getline(v:lnum)=~'^#\\s*--.*--$'
aug END "}}}

fun! s:check_html() "{{{
    " The html template file place
    if expand('<afile>:p') =~ '\v[/\\]%(template|views)[/\\]'
        set ft=html
    endif
endfun "}}}
fun! s:check_ft() "{{{
    " The django file place
    if expand('<afile>:p') =~ '\v[/\\]%(templates|views)[/\\]'
        set ft=htmldjango
    endif
endfun "}}}

function! s:hlp_fold() "{{{
    setl foldmethod=syntax
    setl foldtext=MyHlpFoldText()
    syn region foldBraces start=/[-=]\{50,}/
                \ end=#\ze[-=]\{50,}# transparent fold keepend
endfunction "}}}
function! MyHlpFoldText() "{{{
    let dash = getline(v:foldstart)[0]
    let line = getline(v:foldstart+1)
    let num  = printf("%4s",(v:foldend-v:foldstart))
    let line = substitute(line, '\%>44c\%<53c', '['.dash.num.']', '')
    return line
endfunction "}}}

" JavaScript {{{2
function! s:js_fold() "{{{
    " setl foldmethod=syntax
    syn region foldBraces start=/{/ skip=#/\%([^/]\|\/\)*/\|'[^']*'\|"[^"]*"#
                \ end=/}/ transparent fold keepend extend
endfunction "}}}
" }}}

" Resize the divisions if the Vim window size changes {{{

au VimResized * exe "normal! \<c-w>="

" Execution permissions by default to shebang (#!) files {{{

augroup shebang_chmod
  autocmd!
  autocmd BufNewFile  * let b:brand_new_file = 1
  autocmd BufWritePost * unlet! b:brand_new_file
  autocmd BufWritePre *
        \ if exists('b:brand_new_file') |
        \   if getline(1) =~ '^#!' |
        \     let b:chmod_post = '+x' |
        \   endif |
        \ endif
  autocmd BufWritePost,FileWritePost *
        \ if exists('b:chmod_post') && executable('chmod') |
        \   silent! execute '!chmod '.b:chmod_post.' "<afile>"' |
        \   unlet b:chmod_post |
        \ endif
augroup END
" }}}

fu! s:getparent(item)
    let parent = substitute(a:item, '[\/][^\/]\+[\/:]\?$', '', '')
    if parent == '' || parent !~ '[\/]'
        let parent .= '/'
    en
    retu parent
endf


fun! s:set_path()

    let markers = ['.git', '.hg', '.svn', '.bzr', '_darcs', 'package.json']
    " setl path =
    let root =  s:findroot(getcwd(), markers, 0)

    setl path+=/usr/local/lib/node_modules
    if !empty(root)
        exec "setl path+=".root[1]
        exec "setl path+=".root[1].'/node_modules'
    endif

    setl includeexpr=join([v:fname,'index.js'],'/')

endfun


fu! s:findroot(curr, mark, depth)
    let [depth, fnd] = [a:depth + 1, 0]
    if type(a:mark) == 1
        let fnd = s:glbpath(s:fnesc(a:curr, 'g', ','), a:mark, 1) != ''
    elsei type(a:mark) == 3
        for markr in a:mark
            if s:glbpath(s:fnesc(a:curr, 'g', ','), markr, 1) != ''
                let fnd = 1
                brea
            en
        endfo
    en
    if fnd
        retu [exists('markr') ? markr : a:mark, a:curr]
    elsei depth > 10
        echo '>10'
    el
        let parent = s:getparent(a:curr)
        if parent != a:curr
            retu s:findroot(parent, a:mark, depth)
        en
    en
    retu []
endf

fu! s:glbpath(...)
    retu call('ctrlp#utils#globpath', a:000)
endf

fu! s:fnesc(...)
    retu call('ctrlp#utils#fnesc', a:000)
endf

auto! BufWritePost vimrc source %
auto! BufWritePost index.vim source %
auto! BufWritePost ~/.dot.vim/**/*.vim source %

" mapping


" with input method "{{{ 1
" se imi=2

nmap ： :


"{{{ 1
noremap <C-CR> gJ

" Clear screen

if &term == "xterm"
    nno <c-r>  <c-v>
endif

" Moving
nno   H   h
nno   L   l
nno   J   j
nno   K   k
nno   j   gj
nno   k   gk

vno   j  gj
vno   k  gk

nno   gK  K
nno   gJ  J

" nno   <leader>   <Nop>
" vno   <leader>   <Nop>
nno   s          <Nop>
nno   S          <Nop>
nno   c          <Nop>
nno   Q          <Nop>
nno   q          <Nop>
nno   gq         q
nno   <nowait> q:      :


" use x or d to delete selected
            vno s <nop>
            vno c <nop>

" similar with D
" nno   yy         "*yy
" nno   Y          "*y$
" nno   p          "*p
nno   cc        <nop>
" nno   dd         "*dd
" nno   D          "*D
" vno   y          "*y
" vno   d          "*d
" vno   x          "*x

nno <nowait>  >          >>
nno <nowait>  <          <<
vno   <          <gv
vno   >          >gv

" repeat on every line
vno   .          :normal .<CR>
nor <rightmouse><leftmouse> <c-o>
nor <rightmouse><rightmouse> <c-o>
nor <rightrelease><leftrelease> <c-o>
ino <rightrelease><leftrelease> <c-o><c-o>



" Window
nno <silent><C-W>1 :resize<cr>
" nno <silent><C-W>2 :vert resize<cr>
nno <silent><C-W>2 <C-W>=


" nno <silent><A-1>  :if &go=~#'m' \| set go-=m \| else \| set go+=m \| endif<CR>
" nno <silent><A-2>  :if &go=~#'e' \| set go-=e \| else \| set go+=e \| endif<CR>

nno <C-W>n <C-W>w
nno <C-W>N <C-W>n

" smarter opening files. 
" TODO
" should replace with click.vim
fun! s:edit_file(ask)
    let file = expand('<cfile>')
    if file == "\\" || file == "\\\\"
        return
    endif

    let ptn ='\v(%(file|https=|ftp|gopher)://|%(mailto|news):)([0-9a-zA-Z#&?._-~/]*)'
    let links = matchlist(file,ptn)
    if !empty(links)
        if links[1] =~ 'file'
            let file = links[2]
        else
            sil! exe "!firefox ". links[2]
        endif
        return
    endif
    let file = expand(file)
    if filereadable(file) || isdirectory(file)
        exe "edit ".file
        return
    elseif a:ask==1 && input("file: ".file." not exists, continue?(Y/n)") =~?"y"
        exe "edit ".file
        return
    endif

    " find the file match with <cfile>.ext
    if file !~ '^\s*$'
        let files = split(glob(expand('%:p:h')."/".file.".*"),'\n')
        if !empty(files)
            exe "edit ".files[0]
            for f in files[1:]
                exe "split ".f
            endfor
            return
        endif
    endif
endfun 
nno <silent><C-W>v :vsp\|call <SID>edit_file(0)<CR>
nno <silent><C-W>s :sp\|call <SID>edit_file(0)<CR>
nno <silent><C-W><C-V> :on\|vsp\|call <SID>edit_file(0)<CR>
nno <silent><C-W><C-S> :sp\|call <SID>edit_file(0)<CR>
nno <silent><C-W><C-T> :tab sp\|call <SID>edit_file(0)<CR>
nno <silent><C-W><C-F> :sp\|call <SID>edit_file(1)<CR> 



" Save
nnoremap <c-s> :w<CR>
nnoremap <m-s> :w<CR>

nno <silent><C-W>q :call <SID>close_win_keep_last()<CR>
nno <silent><C-W><C-Q> :call <SID>close_win_keep_last()<CR>
tno <silent><C-W><C-Q> <C-C><C-W>N:call <SID>close_win_keep_last()<CR>
tno <silent><C-W>q <C-C><C-W>N:call <SID>close_win_keep_last()<CR>

function! s:close_win_keep_last()
    if winnr('$') == 1
        echo "is last window"
    else
        if getbufvar(bufnr(), '&buftype') == 'terminal'
            exe "bw!"
        else
            exe "quit"
        endif
    endif
endfunction

" syntax dev tool (vim dev) 
nma <silent><leader>1ss :call <SID>synstack()<CR>
function! s:synstack() 
    if exists("*synstack")
        for id in synstack(line("."), col("."))
            echon " ".synIDattr(id, "name")
            exe "echoh ".synIDattr(id, "name")
            echon "[".synIDattr(synIDtrans(id), "name")."]"
            echoh None
        endfor
    endif
endfunc 
function! s:editstack()
    if exists("*synstack")
        let id = synstack(line("."), col("."))[0]
            split
            exec "edit $VIMRUNTIME/syntax/" .b:current_syntax. ".vim"
            call search(synIDattr(id, "name"),'c')
            update
            echoe " ".synIDattr(id, "name")
            exe "echoh ".synIDattr(id, "name")
            echon "[".synIDattr(synIDtrans(id), "name")."]"
            echoh None
    endif
endfunc

nma <silent><leader>1sn :exec "edit $VIMRUNTIME/syntax/" .b:current_syntax. ".vim"<CR>
nma <silent><leader>1se :call <SID>editstack()<CR>

" function keys
function! s:escape(p,mode) "{{{
    " escape word
    if a:mode =~ "s"
        let re_txt =  ''
    elseif a:mode =~ "e"
        let re_txt =  '*[]/~.$\'
    elseif a:mode =~ "r"
        let re_txt =  '&'
    endif
    return escape(a:p,re_txt)
endfunction "}}}
function! s:p(p,mode) "{{{
    if a:mode =~ "s"
        let re_txt =  ''
    elseif a:mode =~ "e"
        let re_txt =  '*[]/~.$\'
    elseif a:mode =~ "r"
        let re_txt =  '&'
    endif
    return escape(a:p,re_txt)
endfunction "}}}
function! s:r() "{{{
    normal gv"yy
    let w = @y
    return w
endfunction "}}}
function! s:w(s,mode) "{{{
    let rs = a:s
    if a:mode =~ "b"
        let ss = "\\<".s:p(a:s,"s")."\\>"
    else
        let ss = s:p(a:s,"s")
    endif
    return 's/'.ss."/".s:p(rs,"r")."/gc"
endfunction "}}}

function! s:substitute(s,mode) "{{{
    " get the substitute part
    let rs = a:s
    if a:mode =~ "b"
        let ss = "\\<".s:escape(a:s,"s")."\\>"
    else
        let ss = s:escape(a:s,"s")
    endif
    return 's/'.ss."/".s:escape(rs,"r")."/gc"
endfunction "}}}

" let s:k = require.at('search', expand('<sfile>:p'))
" Require search

vno   /    <ESC>/<C-\>e<SID>p(<SID>r(),"e")<CR>
vno   ?    <ESC>?<C-\>e<SID>p(<SID>r(),"e")<CR>
vno   #    <ESC>/<C-\>e<SID>p(<SID>r(),"e")<CR><CR><C-G>
vno   *    <ESC>?<C-\>e<SID>p(<SID>r(),"e")<CR><CR><C-G>
vno   n    <ESC>/<C-\>e<SID>p(<SID>r(),"e")<CR><CR><C-G>
vno   N    <ESC>?<C-\>e<SID>p(<SID>r(),"e")<CR><CR><C-G>

nno # /<C-R><C-W><CR>

augroup help
    autocmd!
    au BufRead,BufNewFile *.vim set kp=
    au FileType vim set kp=
    au FileType bash set kp=man
augroup END

nor   <F1>   K
nor   <M-1>   K
" nno   <s-F2> :%<C-R>=<SID>substitute(@/,"\x00")<CR><Left><Left><Left>
" vno   <s-F2> :<C-R>=<SID>substitute(@/,"\x00")<CR><Left><Left><Left>
" nno   <F2>   :%<C-R>=<SID>substitute(expand('<cword>'),"b")<CR><Left><Left><Left>
" vno   <F2>   :<C-R>=<SID>substitute(expand('<cword>'),"b")<CR><Left><Left><Left>
nno   <F2>     :%<C-R>=search.generate(@/,"\x00")<CR><Left><Left><Left>
vno   <F2>     :<C-R>=<SID>w(@/,"\x00")<CR><Left><Left><Left>
nno   <M-2>     :%<C-R>=search.generate(@/,"\x00")<CR><Left><Left><Left>
vno   <M-2>     :<C-R>=<SID>w(@/,"\x00")<CR><Left><Left><Left>

nno   <S-F2>   :%<C-R>=<SID>w(expand('<cword>'),"b")<CR><Left><Left><Left>
vno   <S-F2>   :<C-R>=<SID>w(expand('<cword>'),"b")<CR><Left><Left><Left>
nno   <S-M-2>   :%<C-R>=<SID>w(expand('<cword>'),"b")<CR><Left><Left><Left>
vno   <S-M-2>   :<C-R>=<SID>w(expand('<cword>'),"b")<CR><Left><Left><Left>

" TODO: use c_Ctrl-\_e to finish this.
" XXX
" % can not be used.
" nno   <s-F1> :%<C-\>e<SID>sub2(expand('<cword>'),"\x00")<CR>

imap  <F2>   <C-O>:set paste<CR>
imap  <F3>   <C-O>:set nopaste<CR>

"{{{3 F3 Ack-grep http://better-than-grep.com
" exists ag or grep
nor   <S-F3>     :Ag <C-R><C-F><CR>
vno   <S-F3>     y:Ag <C-R>"<CR>
nor   <F3>   :Ag 
vno   <F3>   y:Ag <C-R>"<CR>
nor   <S-M-3>     :Ag <C-R><C-F> %<CR>
vno   <S-M-3>     y:Ag <C-R>" %<CR>
nor   <M-3>   :Ag 
vno   <M-3>   y:Ag <C-R>"<CR>

"{{{3 F4 Folder
nno <silent> <F4> :call <SID>toggle_nerdfind()<CR>
nno <leader>ee  :call <SID>toggle_nerdfind()<CR>
nno <c-e>ee  :call <SID>toggle_nerdfind()<CR>
nno <silent> <M-4> :call <SID>toggle_nerdfind()<CR>
" nno <silent> <F4> :Fern . -drawer -toggle -reveal=% -stay<CR>
nno <silent> <C-T> :call <SID>toggle_nerdfind()<CR>
" nno <silent> <F5> :call <SID>exe("n")<CR>
" vno <silent> <F5> :call <SID>exe("v")<CR>
" nno <silent> <D-r> :call <SID>exe("n")<CR>
nno <silent> <leader>rn :call <SID>exe("n")<CR>

com! -nargs=0 Dir call <SID>file_man()
com! -nargs=0 Term call <SID>terminal()

" nor   <F7>   :GundoToggle<CR>
nor   <F8>   :Dir<CR>
" nor   <F6>   :Sexe yarn test<CR>
nor   <leader>rt :Sexe yarn test<CR>

function! s:toggle_nerdfind() "{{{
    if exists("t:nerdwin") && t:nerdwin==1
        NERDTreeClose
        let t:nerdwin=0
    else
        NERDTreeFind
        let t:nerdwin=1
    endif
endfunction "}}}


function! s:exe(mode) "{{{
    update
    let bang="!"
    if g:os.is_mac
        let browser = 'open -a "Google Chrome" -g'
        let runner="open "
        let err_log=" "
        let term = "iTerm "
    elseif g:os.is_unix
        let browser = "firefox "
        let runner="xdg-open "
        let err_log=" 2>&1 | tee /tmp/.vim_exe.tmp"
        let term = "gnome-terminal "
    else
        let browser ="firefox.lnk "
        let runner="start "
        let err_log=" "
        let term = "cmd "
    endif

    if !exists("&syn")
        exec bang.runner.file
        return
    else
        let syn=&syn
    endif

    if a:mode=="n"
        let file=' "'.expand('%:p').'"'
        if    syn=="python"
            let    L=getline(1)
            if     L=~'python3' | exec "!python3 -d ".file.err_log
            elsei  L=~'pyfile'
                if has("python")
                    pyfile %
                else
                    exec "!python -d ".file.err_log
                endif
            elsei  L=~'pypy'    | exec "!pypy -d ".file.err_log
            else                | exec "!python -d ".file.err_log
            endif
        elsei syn=="ruby"
            if has("ruby")
                rubyfile %:p
            else
                exec "!ruby ".file.err_log
            endif
        elsei syn=="perl"       | exec "!perl -D ".file.err_log
        elsei syn=="lua"        | exec "luafile %"
        elsei syn=='vim'        | exec "so %"
        elsei syn=='gdscript'   | exec "!godot -u"
        elsei syn=='plantuml'   | silent make
        elsei syn=~'html'       | exec bang.browser.file
        elsei syn=='rst'        | Riv2HtmlAndBrowse
        elsei syn=~'^coffee$'   | exec "CoffeeRun"
        elsei syn=="vimwiki"    | exec "Vimwiki2HTMLBrowse"
        elsei syn=='bat'        | exec "w !cmd"
        elsei syn=='javascript' | exec "Dispatch node %"
        elsei syn=='go'         | exec "!go run %"
        elsei syn=='make'       | make
        elsei syn=='haskell'    | exec "!ghc %" | exec "!./%:t:r"
        elsei syn=='cpp' || syn=='c' | call s:gcp()  | exec "!./%:t:r"
        elsei syn=~'^\(sh\|expect\|bash\)$'     | exec "w !sh"
        else                    | exec bang.runner.file
        endif
    elseif a:mode=="v"
        if     syn=="python"    | exec "py ".getline('.')
        elseif syn=="ruby"      | exec "ruby ".getline('.')
        elseif syn=="lua"       | exec "lua".getline('.')
        elseif syn=='vim'       | exec getline('.')
        elseif syn=~'^\(sh\|expect\|bash\)$'    | exec ".w !sh"
        endif
    endif
endfunction "}}}
function! s:gcp() "{{{
    let lf = ''
    for l in getline(1,10)
        if l =~ 'gtk\|gdk'
            let lf .= 'g'
        endif
        if l =~ 'math'
            let lf .= 'm'
        endif
    endfor
    let lib=''
    if lf =~ 'g'
        let lib .=' `pkg-config --cflags --libs gtk+-2.0` '
    endif
    if lf =~ 'm'
        let lib .= ' -lm '
    endif
    exec "!gcc -Wall " . lib . " -o %:t:r %"
endfunction "}}}
function! s:file_man() "{{{
    if g:os.is_windows
        sil exec '!start explorer "%:p:h"'
    elseif g:os.is_mac
        sil exec "!open '%:p:h'"
    else
        " sil exec "!nemo %:p"
        sil call job_start(['nemo', expand('%:p')])
    endif
endfunction "}}}
function! s:terminal() "{{{
    if _v.is_windows | exec '!start cmd "%:p:h"'
    else            | exec "!urxvt -cd %:p:h &"
    endif
endfunction "}}}
" pair
"
" Pairs "{{{
" vno q< <esc>`>a><esc>`<i<<esc>lv`>l
" vno q{ <esc>`>a}<esc>`<i{<esc>lv`>l
" vno q( <esc>`>a)<esc>`<i(<esc>lv`>l
" vno q" <esc>`>a"<esc>`<i"<esc>lv`>l
" vno q' <esc>`>a'<esc>`<i'<esc>lv`>l
" vno q* <esc>`>a*<esc>`<i*<esc>lv`>l
" vno q_ <esc>`>a_<esc>`<i_<esc>lv`>l

" NOTE:
" The ino is disabled when 'paste' optin is on.
function! s:init_pair()

    let pair_list = [ ['{','}'], ['[',']'], ['(',')'], ['<','>'],
                    \ ['"','"'], ["'","'"],
                    \ ['｛','｝'], ['［','］'], ['（','）'], ['＜','＞'],
                    \ ['＂','＂'], ["＇","＇"],["`","`"]
                    \ ]

    for [s,e] in pair_list

        " Input style 1: 1to1 & 2to2
        exec 'ino '.s.  ' '.s
        exec 'ino '.s.s.' '.s.e.'<left>'
        exec 'cno '.s.s.' '.s.e.'<left>'
        exec 'cno '.s.  ' '.s
        
        " " Input style 2: 1to2 & 2to1
        " " easier to inpu a single s , but often mistake for two quote
        " exec 'ino '.s.' '.s.e.'<left>'
        " exec 'ino '.s.'<esc> '.s
        " exec 'ino '.s.s.' '.s
        " exec 'cno '.s.' '.s.e.'<left>'
        " exec 'cno '.s.s.' '.s
        " exec 'cno '.s.'<esc> '.s

        exec 'ino '.e.'<c-a> '.e.'<esc>m`^i'.s.'<esc>``a'
        exec 'ino '.e.'<c-b> '.e.'<esc>m`bi'.s.'<esc>``a'
        exec 'cno '.e.'<c-a> '.e.'<home>'.s
        exec 'cno '.e.'<c-b> '.e.'<s-left>'.s
        exec 'ino '.s.'<c-e> '.s.'<esc>m`$a'.e.'<esc>``a'
        exec 'ino '.s.'<c-w> '.s.'<esc>m`ea'.e.'<esc>``a'
        exec 'cno '.s.'<c-e> '.s.'<end>'.e
        exec 'cno '.s.'<c-w> '.s.'<s-right>'.e

        exec 'vno q'.s .' <esc>`>a'.e.'<esc>`<i'.s.'<esc>lv`>l'

        if s != e
            exec "ino ".s.e." ".s.e
        endif

        unlet s
        unlet e
    endfor
endfunction
call <SID>init_pair()

ino {<CR>  {<CR>}<Esc>O<tab>
ino {<c-e> {<c-o>mz<end><cr>}<c-o>`z<cr><tab>
" search
let search = {}

fun! search.escape(ptn, mode)
    if a:mode == "search"
        return escape(a:ptn, '')
    elseif a:mode == "edit"
        return escape(a:ptn, '*[]/~.$\')
    elseif a:mode == "replace"
        return escape(a:ptn, '&')
    endif
endfun
fun! search.getvis()
    normal gv"yy
    return @y
endfun

fun! search.generate(word,mode) dict "{{{
    let rs = a:word
    if a:mode =~ "b"
        let ss = "\\<". self.escape(a:word,"search") ."\\>"
    else
        let ss = self.escape(a:word,"search")
    endif
    return "s/".ss."/".a:word. "/gc" 
endfunction "}}}

