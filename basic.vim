set path+=/usr/local/bin

set mmp=100000

" terminal
set bo=all

" terminal color
let g:terminal_ansi_colors = 
            \['#616161', '#f08978', '#c3f884', '#fefdc8', '#afd4fa', '#f295f7', '#d0d1fa', '#f1f1f1'
            \,'#8e8e8e', '#f7c6bf', '#ddfbc0', '#fefdd9', '#c8e2fc', '#f5b5f9', '#e5e6fc', '#fffeff']

" Editing
set ff=unix
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8
scriptencoding utf-8
language messages en_US.utf-8


set sua+=.js,.css,.html,.vim,.vue,.styl

set nopaste
set pastetoggle=<F2>
set autoread                    " update a open file edited outside of Vim
set ttimeoutlen=0               " toggle between modes almost instantly

set backspace=indent,eol,start  " defines the backspace key behavior
" set virtualedit=all             " to edit where there is no actual character
set virtualedit=block             " to edit where there is no actual character


" Tabs, space and wrapping
set expandtab                  " spaces instead of tabs
set tabstop=4                  " a tab = four spaces
set shiftwidth=4               " number of spaces for auto-indent
set softtabstop=4              " a soft-tab of four spaces
set autoindent                 " set on the auto-indent
set smartindent                " indent on some case


if has('unnamedplus')
    set clipboard=autoselectplus,unnamedplus,exclude:cons\|linux
else
    set clipboard=autoselect,unnamed
endif

" Commands
com! Copy let @+ = expand('%:p')|echo 'PATH:'.@+
com! Pwd let @+ = expand('%:p:h')|echo 'PATH:'.@+
com! Trail call Trim()
com! Trim call Trim()

cabbrev ss so %
cabbrev E e
cabbrev dir Dir
cabbrev trim Trim
cabbrev copy Copy


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
set foldmethod=syntax "{{{
set foldcolumn=0
set foldlevel=0 foldlevelstart=1
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo "}}}
set foldclose=

nno <silent> zf :set opfunc=MyFoldMarker<CR>g@
vno <silent> zf :<C-U>call MyFoldMarker(visualmode(), 1)<CR>zv
nno <silent> zz @=(&foldlevel?'zM':'zR')<CR>
nno <silent> <leader>zz @=(&foldlevel?'zM':'zR')<CR>
nno <silent> <leader><leader> @=(foldclosed('.')>0?'zv':'zc')<CR>
vno <silent> <leader><leader> <ESC>@=(foldclosed('.')>0?'zv':'zc')<CR>gv
nor <2-rightmouse> @=(foldclosed('.')>0?'zv':'zc')<CR>
vno <2-rightmouse> <ESC>@=(foldclosed('.')>0?'zv':'zc')<CR>gv
nor <silent> <leader>ff :setl fdm=<C-R>=&fdm=~'mar'?'indent'
            \:&fdm=~'ind'?'syntax'
            \:&fdm=~'syn'?'expr':'marker'<CR><BAR>ec &fdm<CR>
function! MyFoldText() "{{{
    let markers = split(&foldmarker, ",")
    let cmtmakrer = substitute(&commentstring, "%s", markers[0], "\x00")
    let sub = markers[0].'\d\=\|'.cmtmakrer.'\d\='
    let line = substitute(getline(v:foldstart), sub, '', 'g')
    let pre_white= matchstr(line,'^\s*')
    let m_line = winwidth(0)-10
    if len(line)<=m_line 
        let line = line."  ".repeat('-',m_line) 
    else
        " trim preceding whitespace to 50
        if len(pre_white)>=m_line
            let line = substitute(line,'^\s*',repeat(' ',m_line-10),'')
        endif
    endif
    let line = printf("%-".m_line.".".m_line."s",line)
    if v:foldlevel < 4
        let dash = printf("%4s",repeat("<",v:foldlevel))
    else
        let dash = " <<+"
    endif
    let num = printf("%4s",(v:foldend-v:foldstart))
    return line."[".num.dash."]"
    " return "+-" . v:folddashes.printf("%3d",(v:foldend-v:foldstart)).
    "     \ " lines: " . line
endfunction "}}}
function! MyFoldMarker(type, ...) "{{{
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@

    if a:0  " Invoked from Visual mode, use '< and '> marks.
        call s:set_fold_markers("'<", "'>")
    elseif a:type == 'line'
        call s:set_fold_markers("'[", "']")
    elseif a:type == 'block'
    endif

    let &selection = sel_save
    let @@ = reg_save
endfunction "}}}
function! s:set_fold_markers(lnum_st, lnum_end) "{{{
    " let foldmarkers to be applied with space before a comment.
    let markers = split(&foldmarker, ",")

    function! s:set_line(ln, marker)
        let cmnt = substitute(&commentstring, "%s", a:marker, "\x00")
        let line = getline(a:ln)
        if line =~ '^\s*$'
            let space = ''
        else
            let space = ' '
        endif
        let line = substitute(line, '\s*$', space, '').cmnt
        call setline(a:ln, line)
    endfunction

    call s:set_line(a:lnum_st, markers[0])
    call s:set_line(a:lnum_end, markers[1])
endfunction "}}}

" history
" History and permanent undo levels {{{

set history=1000
set undofile
set undoreload=1000

" }}}
" Make a dir if no exists {{{

function! MakeDirIfNoExists(path)
    if !isdirectory(expand(a:path))
        call mkdir(expand(a:path), "p")
    endif
endfunction

" }}}

" Backups {{{

set backup
set noswapfile
set backupdir=$HOME/.vim/tmp/backup/
set undodir=$HOME/.vim/tmp/undo/
set directory=$HOME/.vim/tmp/swap/
set viminfo+=n$HOME/.vim/tmp/viminfo

" make this dirs if no exists previously
silent! call MakeDirIfNoExists(&undodir)
silent! call MakeDirIfNoExists(&backupdir)
silent! call MakeDirIfNoExists(&directory)
" }}}
"
if g:os.is_windows
    " ms win alike
    "
    source $VIMRUNTIME/mswin.vim

    " Undo/Redo, add 'zv' to view redo/undo line
    nor <C-Z>       uzv
    ino <C-Z>       <C-O>u<C-O>zv
    vno <C-Z>       <Nop>

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



endif

if g:os.is_linux
    if has("clipboard")
        " CTRL-X and SHIFT-Del are Cut
        vnoremap <C-X> "+x
        vnoremap <S-Del> "+x

        " CTRL-C and CTRL-Insert are Copy
        vnoremap <C-C> "+y
        vnoremap <C-Insert> "+y

        " CTRL-V and SHIFT-Insert are Paste
        map <C-V>		"+gP
        map <S-Insert>		"+gP

        cmap <C-V>		<C-R>+
        cmap <S-Insert>		<C-R>+
    endif
endif

" search
set incsearch                   " incremental searching
set showmatch                   " show pairs match
set hlsearch                    " highlight search results
set smartcase                   " smart case ignore
set ignorecase                  " ignore case letters
set nowrapscan			        " no wrapping search

" statusline
" from https://github.com/chemzqm/vimrc
let s:job_status = {}

function! MyStatusSyntaxItem()
  return synIDattr(synID(line("."),col("."),1),"name")
endfunction

function! MyStatusLine()
  let errorMsg = has('nvim') ? "%= %3*%{MyStatusLocError()}%* %=" : ""
  return s:GetPaste()
        \. "%4*%{MyStatusGit()}%*"
        \. "%5*%{MyStatusGitChanges()}%*"
        \. " %{MyStatusTsc()} %{Fname(g:actual_curbuf)} %{MyStatusRunningFrame()} %{MyStatusModifySymbol()}"
        \. " %{MyStatusReadonly()} "
        \. errorMsg
        \. "%="
        \. MyStatusFile()
        \. " %-{&ft} %l,%c %P "
"%{&fenc}
endfunction


" XXX!
" Seems you can only get the CURRENT buffer (editing one)
" but don't know if it's !ACTIVE / !INACTIVE while render statusline
"
" the g:actual_curbuf not work
" so even a %f  or %n can not be get
"
"
" NOTE: use %{} to get the exec buffer context
fun! Echo()
    return bufnr('%')
endfun
" show :p:.
function! Fname(cur) abort

  " return bufname(a:buf)
  let fname = bufname(a:cur)
  " return bufnr(a:cur)
  " return fname
  if a:cur == bufnr('%')
    " return ' yes '
    " return fnamemodify(fname, ':p:.')
    return expand('%:p:h:t') . '/' . expand('%:t')
  else
    return expand('%:.')
    " return ' not '
  endif
  " return expand('%:p:h')
endfunction

fun! GetGitDir()
    let full = expand('%:p:h')

    let p_len = len(split(full, '/'))
    let parents = map(range(p_len), 'fnamemodify(full, repeat(":h" ,v:val))')
    call map(parents, 'v:val."/.git"')
    call filter(parents, 'isdirectory(v:val)')

	if len(parents) > 0
		let main = fnamemodify(parents[0], ':h:t')
        return ' '. main. ' '
    else 
        return ''
    endif
    
endfun




fun! MyStatusFile()
    " return '%{Echo()}'
    " return '%n %{Echo()}'
    " return bufnr('%')
    " return exists("g:actual_curbuf") ? g:actual_curbuf : 'NONE'
    return '%#MyStatusLineTitle#%{GetGitDir()}%*'


    let full = expand('%:p:h')
    let name = expand('%:t')

    let p_len = len(split(full, '/'))
    let parents = map(range(p_len), 'fnamemodify(full, repeat(":h" ,v:val))')
    call map(parents, 'v:val."/.git"')
    call filter(parents, 'isdirectory(v:val)')

	if len(parents) > 0
		let main = fnamemodify(parents[0], ':h:t')
		let full_fix = substitute(full, main, '#####','')
		let trim = fnamemodify(full_fix, ':gs?\([^/#]\)[^/#]*?\1?')
		let trim_rev = substitute(trim, '#####', '%#StatusLine#'.main.'%#StatusLineNC#','')
		return "%#StatusLineNC#"  . trim_rev .'/%*'  . '%{Echo(%n)}'
	else
        return ''
	endif
	


    " return "%#StatusLineNC#"  . trim.'/%*' . name
    
endfun

function! s:IsTempFile()
  if !empty(&buftype) | return 1 | endif
  if &filetype ==# 'gitcommit' | return 1 | endif
  if expand('%:p') =~# '^/tmp' | return 1 | endif
endfunction

function! s:GetPaste()
  if !&paste | return '' |endif
  return "%#MyStatusPaste# paste %*"
endfunction

function! MyStatusReadonly()
  if !&readonly | return '' |endif
  return "  "
endfunction

function! MyStatusRunningFrame()
  let s = get(g:, 'tslint_frame', '')
  return s
endfunction

function! MyStatusTsc()
  if s:IsTempFile() | return '' | endif
  let s = get(g:, 'tsc_status', '')
  if s ==? 'init'
    return ''
  elseif s ==? 'running'
    return '🌴'
  elseif s ==? 'stopped'
    return '⚪️'
  elseif s ==? 'error'
    return '🔴'
  endif
  return ''
endfunction

function! MyStatusModifySymbol()
  return &modified ? '⚡' : ''
endfunction

function! MyStatusGitChanges() abort
  if s:IsTempFile() | return '' | endif
  let gutter = get(b:, 'gitgutter', {})
  if empty(gutter) | return '' | endif
  let summary = get(gutter, 'summary', [])
  if empty(summary) | return '' | endif
  if summary[0] == 0 && summary[1] == 0 && summary[2] == 0
    return ''
  endif
  return '  +'.summary[0].' ~'.summary[1].' -'.summary[2].' '
endfunction

function! MyStatusGit(...) abort
  if s:IsTempFile() | return '' | endif
  let reload = get(a:, 1, 0) == 1
  if exists('b:git_branch') && !reload | return b:git_branch | endif
  if !exists('*FugitiveExtractGitDir') | return '' | endif
  if s:IsTempFile() | return '' | endif
  " only support neovim
  if !exists('*jobstart') | return '' | endif
  let roots = values(s:job_status)
  let dir = get(b:, 'git_dir', FugitiveExtractGitDir(resolve(expand('%:p'))))
  if empty(dir) | return '' | endif
  let b:git_dir = dir
  let root = fnamemodify(dir, ':h')
  if index(roots, root) >= 0 | return '' | endif
  let nr = bufnr('%')
  let job_id = jobstart('git-status', {
    \ 'cwd': root,
    \ 'stdout_buffered': v:true,
    \ 'stderr_buffered': v:true,
    \ 'on_exit': function('s:JobHandler')
    \})
  if job_id == 0 || job_id == -1 | return '' | endif
  let s:job_status[job_id] = root
  return ''
endfunction

function! s:JobHandler(job_id, data, event) dict
  if !has_key(s:job_status, a:job_id) | return | endif
  if v:dying | return | endif
  let output = join(self.stdout)
  if !empty(output)
    call s:SetGitStatus(self.cwd, ' '.output.' ')
  else
    let errs = join(self.stderr)
    if !empty(errs) | echoerr errs | endif
  endif
  call remove(s:job_status, a:job_id)
endfunction

function! s:SetGitStatus(root, str)
  let buf_list = filter(range(1, bufnr('$')), 'bufexists(v:val)')
  for nr in buf_list
    let path = fnamemodify(bufname(nr), ':p')
    if match(path, a:root) >= 0
      call setbufvar(nr, 'git_branch', a:str)
    endif
  endfor
  redraws!
endfunction

function! SetStatusLine(file)
  if &previewwindow | return | endif
  if s:IsTempFile() | return | endif
  " call MyStatusGit(1)
  " setl statusline=%!MyStatusLine()
  " call s:highlight()
endfunction

function! s:PrintError(msg)
  echohl Error | echon a:msg | echohl None
endfunction

function! s:highlight()
  " hi User3         guifg=#e03131 guibg=#111111
  " hi MyStatusPaste guifg=#F8F8F0 guibg=#FF5F00
  " hi MyStatusPaste ctermfg=202   ctermbg=16    cterm=NONE
  hi User4 guifg=#f8f8ff guibg=#000000
  hi User5 guifg=#f8f9fa guibg=#343a40

    " GET Current Color
    try
        let tabbgcolor=synIDattr(hlID('Tablinefill'), 'bg#')
        let tabselbgcolor=synIDattr(hlID('TablineSel'), 'bg#')
        let statbgcolor=synIDattr(hlID('StatusLine'), 'bg#')
        let statfgcolor=synIDattr(hlID('StatusLine'), 'bg#')
        "
        " exe "hi MyTablineTitle guifg=#99A8CC guibg=".tabbgcolor
        " exe "hi MyTablineSeLTitle guifg=#99A8CC guibg=".tabselbgcolor
        " exe "hi MyStatusLineTitle guifg=#99A8CC guibg=".tabbgcolor
        
    catch /E254/
        
    endtry
endfunction

function! MyStatusLocError()
  let list = filter(getloclist('%'), 'v:val["type"] ==# "E"')
  if len(list)
    return ' ' . string(list[0].lnum) . ' ' . list[0].text
  else
    return ''
  endif
endfunction

augroup statusline
  autocmd!
  " autocmd User GitGutter call SetStatusLine(expand('%'))
  " autocmd BufWinEnter,ShellCmdPost,BufWritePost * call SetStatusLine(expand('%'))
  " autocmd FileChangedShellPost,ColorScheme * call SetStatusLine(expand('%'))
  " autocmd FileReadPre,ShellCmdPost,FileWritePost * call SetStatusLine(expand('%'))
augroup end


set tabline=%!MyTabLine()  " custom tab pages line
function! MyTabLine()
        let s = '' " complete tabline goes here
        " loop through each tab page
        for t in range(tabpagenr('$'))
                " set highlight
                if t + 1 == tabpagenr()
                        let s .= '%#TabLineSel#'
                else
                        let s .= '%#TabLineFill#'
                endif
                " set the tab page number (for mouse clicks)
                let s .= '%' . (t + 1) . 'T'
                if t + 1 == tabpagenr()
                    let s .= '%#MyTablineSelTitle# '
                else
                    let s .= '%#MyTablineTitle# '
                endif
                " set page number string
                let s .= t + 1 . ''
                let full = fnamemodify(bufname(tabpagebuflist(t + 1)[0]), ':p:h')
                let git_full = GetGitDirFull(full)
                let s .= git_full != '' ? ' '. git_full. '' : ''
                let s .=  ' %*'
                " get buffer names and statuses
                let n = ''      "temp string for buffer names while we loop and check buftype
                let m = 0       " &modified counter
                let bc = len(tabpagebuflist(t + 1))     "counter to avoid last ' '
                " loop through each buffer in a tab
                for b in tabpagebuflist(t + 1)
                        " buffer types: quickfix gets a [Q], help gets [H]{base fname}
                        " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
                        if getbufvar( b, "&buftype" ) == 'help'
                                " let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
                                let n .= '[H]'
                        elseif getbufvar( b, "&buftype" ) == 'quickfix'
                                let n .= '[Q]'
                        else
                                " let n .= pathshorten(bufname(b))
                        endif
                        " check and ++ tab's &modified count
                        if getbufvar( b, "&modified" )
                                let m += 1
                        endif
                        " no final ' ' added...formatting looks better done later
                        if bc > 1
                                let n .= ' '
                        endif
                        let bc -= 1
                endfor
                let p = pathshorten(bufname(tabpagebuflist(t + 1)[0]))

                
                let _l = split(p, '/')
                if len(_l) > 4
                    let _l = _l[-4:]
                endif
                let k = join(_l,'/')

                let n .= ' ' .k

                " add modified label [n+] where n pages in tab are modified
                "
                let total = len(tabpagebuflist(t + 1))
                if m > 0
                        let n .= '[' .total . ':' .m . '+]'
                else
                        if total > 1
                            let n .= ' ['.total.']'
                        endif
                endif
                " select the highlighting for the buffer names
                " my default highlighting only underlines the active tab
                " buffer names.
                if t + 1 == tabpagenr()
                        let s .= '%#TabLineSel#'
                else
                        " let s .= '%#TabLine#'
                endif
                
                " add buffer names
                if n == ''
                        let s.= '[New]'
                else
                        let s .= n
                endif
                " switch to no underlining and add final space to buffer list
                let s .= ' '
        endfor
        " after the last tab fill with TabLineFill and reset tab page nr
        let s .= '%#TabLineFill#%T'
        " right-align the label to close the current tab page
        if tabpagenr('$') > 1
                let s .= '%=%#TabLineFill#%999XX'
        endif
        return s
endfunction

fun! GetGitDirFull(full)
    let full = a:full

    let p_len = len(split(full, '/'))
    let parents = map(range(p_len), 'fnamemodify(full, repeat(":h" ,v:val))')
    call map(parents, 'v:val."/.git"')
    call filter(parents, 'isdirectory(v:val)')

	if len(parents) > 0
		let main = fnamemodify(parents[0], ':h:t')
        return main
    else 
        return ''
    endif
    
endfun

" set tabline=%!MyTabLine()
"  UI
" PUT YOUR COLOR SCHEME HERE
" AUTOCMD
"
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
    au FileType javascript,typescript setl sw=2
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
    au FileType gdscript setl fdm=expr
    au FileType gdscript setl fdls=0
    au Filetype gdscript setl shiftwidth=4 expandtab tabstop=4 softtabstop=4
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
let g:mapleader=' '
let g:maplocalleader=' '

nmap <leader>vv :e ~/vim/vim-box-lite/index.vim<CR>
nmap <leader>bb :e ~/.zshrc<CR>

" with input method "{{{ 1
se imd
se ims=1
se noimc
" se imi=2

nmap ： :


"{{{ 1
cmap w!! w !sudo tee % >/dev/null<CR>:e!<CR><CR>
noremap <C-CR> gJ

nor <Leader>li :setl list! list?<CR>

set nonu nornu
nor <leader>nn :setl <c-r>=&rnu?'nornu':&nu?'nonu':'rnu'<CR><CR>
nno <silent><leader>dd :exec &diff ? 'diffoff' : 'diffthis'<CR>

" Clear screen
nno   <silent>   <c-l>   :let @/=''\|redraw!<CR>

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

" nno   <leader>   <Nop>
" vno   <leader>   <Nop>
nno   s          <Nop>
nno   S          <Nop>
nno   c          <Nop>
nno   Q          <Nop>


" use x or d to delete selected
            vno s <nop>
            vno c <nop>

" similar with D
" nno   yy         "*yy
nno   Y          "*y$
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


" let _search = require.at('search', expand('<sfile>:p'))

nor   <F1>   K
" nno   <s-F2> :%<C-R>=<SID>substitute(@/,"\x00")<CR><Left><Left><Left>
" vno   <s-F2> :<C-R>=<SID>substitute(@/,"\x00")<CR><Left><Left><Left>
" nno   <F2>   :%<C-R>=<SID>substitute(expand('<cword>'),"b")<CR><Left><Left><Left>
" vno   <F2>   :<C-R>=<SID>substitute(expand('<cword>'),"b")<CR><Left><Left><Left>
nno   <F2>     :%<C-R>=_search.generate(@/,"\x00")<CR><Left><Left><Left>
vno   <F2>     :<C-R>=<SID>w(@/,"\x00")<CR><Left><Left><Left>
nno   <S-F2>   :%<C-R>=<SID>w(expand('<cword>'),"b")<CR><Left><Left><Left>
vno   <S-F2>   :<C-R>=<SID>w(expand('<cword>'),"b")<CR><Left><Left><Left>

" TODO: use c_Ctrl-\_e to finish this.
" XXX
" % can not be used.
" nno   <s-F1> :%<C-\>e<SID>sub2(expand('<cword>'),"\x00")<CR>

imap  <F2>   <C-O>:set paste<CR>
imap  <F3>   <C-O>:set nopaste<CR>

"{{{3 F3 Ack-grep http://better-than-grep.com
" exists ag or grep
nor   <S-F3>     :Ag <C-R><C-F> %<CR>
vno   <S-F3>     y:Ag <C-R>" %<CR>
nor   <F3>   :Ag 
vno   <F3>   y:Ag <C-R>"<CR>

"{{{3 F4 Folder
nno <silent> <F4> :call <SID>toggle_nerdfind()<CR>
" nno <silent> <F4> :Fern . -drawer -toggle -reveal=% -stay<CR>
nno <silent> <C-T> :call <SID>toggle_nerdfind()<CR>
" nno <silent> <F5> :call <SID>exe("n")<CR>
" vno <silent> <F5> :call <SID>exe("v")<CR>
nno <silent> <D-r> :call <SID>exe("n")<CR>
nno <silent> <leader>rn :call <SID>exe("n")<CR>

com! -nargs=0 Dir call <SID>file_man('')
com! -nargs=0 Term call <SID>terminal()

nor   <F7>   :GundoToggle<CR>
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
    if g:_v.is_mac
        let browser = 'open -a "Google Chrome" -g'
        let runner="open "
        let err_log=" "
        let term = "iTerm "
    elseif g:_v.is_unix
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
function! s:file_man(mode) "{{{
    if g:_v.is_windows
        sil exec '!start explorer "%:p:h"'
    elseif g:_v.is_mac
        sil exec "!open '%:p:h'"
    else
        sil exec "!".a:mode."nautilus '%:p:h' & "
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



fun! search.test2() dict
    echom 1111
    return 1111
endfun


" Export search
" call export.at(s:search, expand("<sfile>:p"))
