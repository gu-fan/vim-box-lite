let g:mapleader=' '
let g:maplocalleader=' '

nnoremap <silent><leader>dd :exec &diff ? 'diffoff' : 'diffthis'<CR>
nno <silent><leader>do :diffget<CR>
nno <silent><leader>dp :diffput<CR>

nor <Leader>ll :setl list! list?<CR>

cmap w!! w !sudo tee % >/dev/null<CR>:e!<CR><CR>

nmap <leader>vv :e ~/.vim/vimrc<CR>
nmap <leader>vz :e ~/.zshrc<CR>
nmap <leader>vn :e ~/.config/nvim/lua/user/mappings.lua<CR>
" nmap <leader>bb :e ~/.bashrc<CR>
" nmap <leader>vt :e ~/.tmux.conf.local<CR>

" the normal yy's yank will always be covered by dd, so set a reg to save it
noremap <leader>yy "jyy
noremap <leader>pp "jp

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
noremap <leader>sn :call SynStack()<CR>


nno <silent> zf :set opfunc=MyFoldMarker<CR>g@
vno <silent> zf :<C-U>call MyFoldMarker(visualmode(), 1)<CR>zv
nno <silent> zc @=(<SID>toggle_fold())<CR>
" nno <silent> zz @=(&foldlevel?'zM':'zR')<CR>
" nno <silent> <leader>zz @=(&foldlevel?'zM':'zr')<CR>
nno <silent> <leader><leader> @=(foldclosed('.')>0?'zA':'zc')<CR>
vno <silent> <leader><leader> <ESC>@=(foldclosed('.')>0?'zA':'zc')<CR>gv
nor <2-rightmouse> @=(foldclosed('.')>0?'zA':'zc')<CR>
vno <2-rightmouse> <ESC>@=(foldclosed('.')>0?'zA':'zc')<CR>gv
nor <silent> <leader>ff :setl fdm=<C-R>=&fdm=~'mar'?'indent'
            \:&fdm=~'ind'?'syntax'
            \:&fdm=~'syn'?'expr':'marker'<CR><BAR>ec &fdm<CR>

function s:toggle_fold()
    let fl = &foldlevel
    let fcl = foldclosed('.')
    if fl > 0 && fcl < 0
        exec 'norm! zM'
    else
        exec 'norm! zr'
    endif
endfunction

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

