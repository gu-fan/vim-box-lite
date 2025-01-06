" ===== General Settings =====
if g:os.is_mac
    " set guifont=Droid\ Sans\ Mono\ for\ Powerline:h18
    " set guifont=3270NF:h24
    set guifont=AgaveNF-Regular:h24
elseif g:os.is_windows
    set guifont=Agave_Nerd_Font:h20:cANSI:qDRAFT
else
    set guifont=Agave\ Nerd\ Font\ Mono\ 16
    set guifontwide=WenQuanYi\ Micro\ Hei\ Mono\ 14
endif

" ===== Key Mappings =====
let mapleader = "\<Space>"
nmap ZZ <nop>

" Fold toggle
nnoremap <silent> <leader><leader> @=(foldclosed('.')>0?'zA':'zc')<CR>
vnoremap <silent> <leader><leader> <ESC>@=(foldclosed('.')>0?'zA':'zc')<CR>gv
" nnoremap <silent> <leader>zz zz
nno <silent> zz @=(&foldlevel?'zM':'zR')<CR>
nno <silent> <leader>zz @=(&foldlevel?'zM':'zR')<CR>

" Yank and paste with a specific register
nnoremap <leader>yy "jyy
nnoremap <leader>pp "jp

" Increment/Decrement
vnoremap + <C-A>
vnoremap - <C-X>
nnoremap + <C-A>
nnoremap - <C-X>
vnoremap _ <C-X>
nnoremap _ <C-X>
noremap <c-3> <c-a>
noremap <c-4> <c-x>
vnoremap <c-3> <c-a>
vnoremap <c-4> <c-x>


nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
vnoremap <M-j> :m '>+1<CR>gv-gv
vnoremap <M-k> :m '<-2<CR>gv-gv


" ===== Custom Functions =====
" Get project root directory
function! s:get_root()
    let cph = expand('%:p:h', 1)
    if cph =~ '^.\+://' | return | endif
    for mkr in ['.git/', '.hg/', '.svn/', '.bzr/', '_darcs/', 'project.godot']
      let wd = call('find'.(mkr =~ '/$' ? 'dir' : 'file'), [mkr, cph.';'])
      if wd != '' | let &acd = 0 | break | endif
    endfor
    return fnameescape(wd == '' ? cph : substitute(wd, mkr.'$', '', ''))
endfunction

" Change to root directory and run Ag
function! s:change_and_ag()
    let root = s:get_root()
    exec 'sp '. root. 'README.rst'
    Ag
endfunction
" command! -bang -nargs=* GGrep call <SID>change_and_ag()
nnoremap <leader>ga :call <SID>change_and_ag()<CR>
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.fzf#shellescape(<q-args>),
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

" ===== Plugin Configurations =====
" Startify
let g:startify_bookmarks = [
    \{'p25':'~/godot/p25_test/README.rst'},
    \{'s2':'~/godot/SLG_P2/temp/Arena.gd'},
    \{'slg':'~/godot/pixel_slg/builders/Battle/BattleCtrl_v2.gd' },
    \{'video':'~/godot/video_runner/README.rst'},
    \]

" Lightline
let g:lightline = {}
let g:lightline.separator = { 'left': "\uE0B0", 'right': "\uE0B2" }
let g:lightline.subseparator = { 'left': "\uE0B1", 'right': "\uE0B3" }

" CtrlP
let g:ctrlp_extensions = [ 'line', 'changes', ]

" LSP Configuration
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" ===== Filetype-specific Settings =====

" ===== Custom Commands =====
command! -bang -nargs=1 E edit <args>
command! -nargs=1 Asplit call <SID>split_layers(<f-args>)

" ===== Abbreviations =====
iabbrev seprate separate
iabbrev sepration separation
iabbrev seperation separation
iabbrev silouette silhouette
iabbrev hide_silouette hide_silhouette
iabbrev show_silouette show_silhouette

" ===== Project-specific Mappings =====
" nnoremap <leader>jj :term godot4 --path /home/ryk/jams/week_rectxian /home/ryk/jams/week_rectxian/main.tscn<CR>
" nnoremap <leader>gf :term godot4 --screen 0 -f --path /home/ryk/godot/p25_test /home/ryk/godot/p25_test/scenes/main.tscn<CR>
nnoremap <leader>gv :term godot4 --verbose --path /home/ryk/godot/p25_test /home/ryk/godot/p25_test/scenes/main.tscn<CR>
nnoremap <leader>gr :term godot4 --path /home/ryk/godot/SLG_P2 --editor<CR>
" nnoremap <leader>gt :term godot4 --path /home/ryk/godot/SLG_P2 /home/ryk/godot/SLG_P2/temp/MainCover.tscn<CR>
nnoremap <leader>rt :term godot4 --headless --path /home/ryk/godot/SLG_P2 -s /home/ryk/godot/SLG_P2/temp/min_test.gd<CR>
nnoremap <leader>rv :sp /home/ryk/godot/SLG_P2/temp/min_test.gd<CR>

" ===== Timer Function =====
let s:timer_id = -1
let s:timer_len = 0

function! s:sleep_await(t)
    if s:timer_id != -1
        call timer_stop(s:timer_id)
        echom 'stopped prev timer'
    endif
    let s:timer_id = timer_start(a:t*1000*60, function('s:end_sleep'))
    let s:timer_len = a:t
    call s:notify('NOTE: started timer of ' . a:t . ' minutes')
endfunction

function! s:end_sleep(...)
    let t = 'NOTE: finished the '. s:timer_len . ' minutes timer'
    call s:notify(t)
    let s:timer_id = -1
endfunction

function! s:notify(txt)
    silent! call system('spd-say -r -40 "' . a:txt . '"')
    call popup_notification(a:txt, #{
            \ pos: 'topright',
            \ col: 999,
            \ line: 1,
            \ minWidth: 24,
            \ time: 4000,
            \ })
endfunction
nnoremap <silent><leader>t1 :call <SID>sleep_await(1)<CR>
nnoremap <silent><leader>t2 :call <SID>sleep_await(3)<CR>
nnoremap <silent><leader>t3 :call <SID>sleep_await(5)<CR>
nnoremap <silent><leader>t4 :call <SID>sleep_await(10)<CR>
nnoremap <silent><leader>t5 :call <SID>sleep_await(20)<CR>
nnoremap <silent><leader>t6 :call <SID>sleep_await(40)<CR>

nnoremap <silent><leader>c1 :call <SID>chafa(40)<CR>
fun! s:chafa(txt)
    let buf = term_start(['chafa', '-s', '40x20', expand('~/Desktop/627f7b1b3e0bcae5c7ed38e219587251.jpg')], #{hidden:1})
	let winid = popup_create(buf, #{minwidth: 40, minheight: 20})
	" let winid = popup_create(buf, #{minwidth: 40, minheight: 20, drag: v:true, border:[1,1,1,1], borderchars:['-', '|', '-', '|', '┌', '┐', '┘', '└']})
	call win_execute(winid, 'noremap <buffer><nowait> q :q<CR>')
endfun


" ===== Aseprite Layer Splitting =====
command! -nargs=1 Asplit call <SID>split_layers(<f-args>)
command! -nargs=0 AsplitAll call <SID>split_all()
function! s:split_all()
    call s:split_layers('full')
    call s:split_layers('base_char')
    call s:split_layers('base_outline')
    call s:split_layers('base_hand')
    call s:split_layers('cloak')
    call s:split_layers('wing')
    call s:split_layers('weapon')
    for lyr in ['cleric', 'fighter', 'ranger']
        call s:split_layers(lyr)
    endfor
endfunction
function! s:split_layers(layer)
    execute 'cd /home/ryk/godot/p25_test/assets/units/hero '
    if a:layer == 'full'
        call s:full_layers()
    elseif a:layer == 'weapon'
        for lyr in ['sword', 'violin', 'shield', 'spear', 'bow']
            call s:run_split(lyr, 256, 'weapon/')
        endfor
    elseif index(['mage', 'fighter', 'rogue', 'ranger', 'cleric', 'vil0'], a:layer) != -1
        call s:run_split(a:layer . '_h', 512)
        call s:run_split(a:layer . '_b', 512)
    elseif index(['wing', 'base_hand'], a:layer) != -1
        call s:run_split(a:layer, 512)
    else
        call s:run_split(a:layer)
    endif
endfunction

function! s:run_split(layer, size=256, prefix='')
    execute "!aseprite -b --layer=" . a:layer . " anim_runner_v2.aseprite --sheet ". a:prefix."tex_".a:layer.".png --data ".a:prefix."data_".a:layer.".json --sheet-width=" . a:size ." --trim --merge-duplicates --list-tags --ignore-empty --filename-format '{layer}:{frame}'"
endfunction

function! s:full_layers()
    execute "!aseprite -b --all-layers --split-layers anim_runner_v2.aseprite --sheet tex_full.png --data data_full.json --sheet-width=256 --trim --merge-duplicates --list-tags --ignore-empty --filename-format '{layer}:{frame}'"
endfunction


com! VTrim call VTrim()
function! VTrim()
    sil! %s#\s\+$##g
    sil! %s#。$##g
    sil! %s#，$##g
    " sil! %s#:#：#g
    sil! %s#;#；#g
    sil! %s#(#（#g
    sil! %s#)#）#g
    w!
endfun
com! VSplit call VSplit()
function! VSplit()
    sil! %s#。#。\r#g
    sil! %s#，#，\r#g
    w!
endfun

augroup filetype_specific
    autocmd!
    autocmd BufRead,BufNewFile *.gd setlocal shiftwidth=4 expandtab tabstop=4 softtabstop=4
augroup END

" nnoremap <silent> <leader>jj :term godot4 --resolution 900x480 --position 2070,750 -t --path /home/ryk/jams/survivor<CR>

nnoremap <silent> <leader>jj :call RunCurrentGodot(1)<CR>
" nnoremap <silent><leader>gg :term godot4 -t --position 2070,750 --resolution 900x480 --path /home/ryk/godot/p25_test /home/ryk/godot/p25_test/scenes/main.tscn<CR>
"

nnoremap <silent><leader>jt :call RunCurrentFile()<CR>
func! RunCurrentFile()
    let project_path = FindProjectRoot('project.godot')
    if project_path is 0
        echom 'RunCurrentScene: Not in godot project directory!'
        return
    end
    let scene_path = expand('%:p')
    exec 'term godot4 --resolution 1200x688 --position 1070,750 -t --path '. project_path . ' ' . scene_path
endfun
nnoremap <silent><leader>gg :call RunCurrentGodot(0)<CR>
nnoremap <silent><leader>gi :call ImportCurrentGodot()<CR>
nnoremap <silent><leader>gf :call RunCurrentScene()<CR>
func! ImportCurrentGodot()
    let path = FindProjectRoot('project.godot')
    if path isnot 0
        exec 'term godot4 --import --path '.path
    else
        echom 'ImportGodot: Not in godot project directory!'
    end
endfun
func! RunCurrentGodot(pos=0)
    let path = FindProjectRoot('project.godot')
    let gd_exe = 'godot4'
    if g:os.is_mac
        let gd_exe = '/Applications/Godot.app/Contents/MacOS/Godot'
    endif
    if path isnot 0
        if a:pos is 0
            " --debug-collisions
            exec 'term ' . gd_exe . ' --screen 2 --resolution 1200x688 -t --path '.path
        else
            exec 'term ' . gd_exe . ' --screen 2 --resolution 1200x688 -t --path '.path
        endif
    else
        echom 'RunGodot: Not in godot project directory!'

    end
endfun
func! RunCurrentScene()
    let project_path = FindProjectRoot('project.godot')
    if project_path is 0
        echom 'RunCurrentScene: Not in godot project directory!'
        return
    end
    let scene_path = FindCurrentScene()
    if scene_path isnot 0
        exec 'term godot4 --resolution 1200x688 --position 1070,750 -t --path '. project_path . ' ' . scene_path
    else
        echom 'RunCurrentScene: Scene not found!'
    end
endfun
function! FindCurrentScene()
    let currentScene = expand('%:p:r') . '.tscn'
    if filereadable(currentScene)
        return currentScene
    else
        return 0
    endif
endfunction
function! FindProjectRoot(lookFor)
    let pathMaker='%:p'
    while(len(expand(pathMaker))>len(expand(pathMaker.':h')))
        let pathMaker=pathMaker.':h'
        let fileToCheck=expand(pathMaker).'/'.a:lookFor
        if filereadable(fileToCheck)||isdirectory(fileToCheck)
            return expand(pathMaker)
        endif
    endwhile
    return 0
endfunction

" set path+=$HOME/.local/bin,$HOME/.pyenv/shims,$HOME/.pyenv/bin
"
" create godot project with template 
" _common directory
" _2d_common
" _3d_common
" _platform_common
" _bug_common
"
