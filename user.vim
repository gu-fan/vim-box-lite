" inoremap <S-Tab> <C-V><Tab>
" inoremap 

" let g:which_key_map =  {}
" let g:which_key_map.t = {
"       \ 'name' : '+timer' ,
"       \ '1' : ['b1'        , 'buffer 1']        ,
"       \ '2' : ['b2'        , 'buffer 2']        ,
"       \ }
"       	   
nmap ZZ <nop>
noremap <c-s-x> <c-a>
nno <silent> <leader><leader> @=(foldclosed('.')>0?'zA':'zc')<CR>
vno <silent> <leader><leader> <ESC>@=(foldclosed('.')>0?'zA':'zc')<CR>gv
nmap <silent> <leader>zz zz

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

"  test 1108 2222
"        000  000
noremap <c-3> <c-a>
noremap <c-4> <c-x>

set guifont=Agave\ Nerd\ Font\ Mono\ 16
set guifontwide=WenQuanYi\ Micro\ Hei\ Mono\ 14

let g:startify_bookmarks = [
    \{'p25':'~/godot/p25_test/README.rst'},
    \{'s2':'~/godot/SLG_P2/temp/Arena.gd'},
    \{'slg':'~/godot/pixel_slg/builders/Battle/BattleCtrl_v2.gd' },
    \{'video':'~/godot/video_runner/README.rst'},
    \]

nmap <leader>vv :e ~/.vim/vimrc<CR>
nmap <leader>vn :e ~/.config/nvim/lua/user/mappings.lua<CR>
" nmap <leader>bb :e ~/.bashrc<CR>
nmap <leader>vz :e ~/.zshrc<CR>
nmap <leader>vt :e ~/.tmux.conf.local<CR>

function! s:has_window(name)
    return system('wmctrl -l | grep "' . a:name . '" 2>&1 | wc -l')
endfunction

" nmap r <nop>

function! s:get_root()
    let cph = expand('%:p:h', 1)
    if cph =~ '^.\+://' | retu | en
    for mkr in ['.git/', '.hg/', '.svn/', '.bzr/', '_darcs/', 'project.godot']
      let wd = call('find'.(mkr =~ '/$' ? 'dir' : 'file'), [mkr, cph.';'])
      if wd != '' | let &acd = 0 | brea | en
    endfo
    return fnameescape(wd == '' ? cph : substitute(wd, mkr.'$', '', ''))
endfunction
fun! s:change_and_ag()
    let root = s:get_root()
    exec 'sp '. root. 'README.rst'
    Ag
endfun

" change to that dir then we can use Ag
command! -bang -nargs=* GGrep call <SID>change_and_ag()
nmap <leader>ga :call <SID>change_and_ag()<CR>
let g:riv_todo_keywords = 'TODO,WIP,XXX,SKIP,DONE'
command! -bang -nargs=1 E edit <args>
cab EDIT edit

" let g:lightline.active = {
"     \ 'left': [ [ 'mode',  'paste' ],
"     \           [ 'session', 'readonly', 'filename', 'modified' ] ],
"     \ 'right': [ [ 'lineinfo' ],
"     \            [ 'percent' ],
"     \            [ 'fileformat', 'fileencoding', 'filetype' ] ] }

" let g:lightline.component = {
"     \ 'session': '%{ObsessionStatus()}',
"     \}

let g:lightline.separator = { 'left': "\uE0B0", 'right': "\uE0B2" }
let g:lightline.subseparator = { 'left': "\uE0B1", 'right': "\uE0B3" }

" -----------------------------------
"  IABBREV
iabbrev seprate separate
iabbrev sepration separation
iabbrev seperation separation
iabbrev silouette silhouette
iabbrev hide_silouette hide_silhouette
iabbrev show_silouette show_silhouette
" -----------------------------------


function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    " nmap <buffer> gs <plug>(lsp-document-symbol-search)
    " nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    " nmap <buffer> gr <plug>(lsp-references)
    " nmap <buffer> gi <plug>(lsp-implementation)
    " nmap <buffer> gt <plug>(lsp-type-definition)
    " nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    " nmap <buffer> K <plug>(lsp-hover)
    " nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    " nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    " let g:lsp_format_sync_timeout = 1000
    " autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" if executable('godot4')
"     au User lsp_setup call lsp#register_server({
"       \ 'name': 'godot',
"       \ 'tcp': {server_info->lsp_settings#get('godot', 'tcp', '127.0.0.1:6005')},
"       \ 'root_uri':{server_info->lsp_settings#get('godot', 'root_uri', lsp_settings#root_uri('godot'))},
"       \ 'initialization_options': lsp_settings#get('godot', 'initialization_options', v:null),
"       \ 'allowlist': lsp_settings#get('godot', 'allowlist', ['gdscript3', 'gdscript']),
"       \ 'blocklist': lsp_settings#get('godot', 'blocklist', []),
"       \ 'config': lsp_settings#get('godot', 'config', lsp_settings#server_config('godot')),
"       \ 'workspace_config': lsp_settings#get('godot', 'workspace_config', {}),
"       \ 'semantic_highlight': lsp_settings#get('godot', 'semantic_highlight', {}),
"       \ })
" endif
"
nnoremap <c-w>M :call system('wmctrl -i -b add,maximized_vert,maximized_horz -r '.v:windowid)<CR>

vno  +  <C-A>
vno  -  <C-X>
nno  +  <C-A>
nno  -  <C-X>
vno  _  <C-X>
nno  _  <C-X>

let g:ctrlp_extensions = [ 'line', 'changes', ]

" -----------------------------------------------------------------
"  DEV RELATED
" -----------------------------------------------------------------
" aseprite split layers
func s:split_layers(layer)
    exec 'cd /home/ryk/godot/SLG_P2/temp '
    if a:layer == 'full'
        call s:full_layers()  " ?? not working for weapon
    elseif a:layer == 'weapon'
        for lyr in ['sword', 'violin', 'shield', 'spear', 'bow' ]
            call s:run_split(lyr)
        endfor
    elseif index(['mage', 'fighter', 'rogue', 'ranger', 'cleric', 'vil0'], a:layer) != -1
        call s:run_split(a:layer . '_h', 512)
        call s:run_split(a:layer . '_b', 512)
    else
        call s:run_split(a:layer)
    endif
endfunc

func s:run_split(layer, size=128)
    exec "!aseprite -b --layer=" . a:layer . " anim_runner_v1.aseprite --sheet tex_".a:layer.".png --data data_".a:layer.".json --sheet-width=" . a:size ." --trim --merge-duplicates --list-tags --ignore-empty --filename-format '{layer}:{frame}'"
endfun

func s:full_layers()
    exec "!aseprite -b --all-layers --split-layers anim_runner_v1.aseprite --sheet tex_full.png --data data_full.json --sheet-width=256 --trim --merge-duplicates --list-tags --ignore-empty --filename-format '{layer}:{frame}'"
endfun

command! -nargs=1 Asplit call <SID>split_layers(<f-args>)

" -----------------------------------------------------------------
au BufRead,BufNewFile *.gd setl shiftwidth=4 expandtab tabstop=4 softtabstop=4

nmap <leader>o1 :e ~/godot/p25_test/README.rst<CR>
nmap <leader>o2 :e ~/godot/SLG_P2/README.md<CR>

" nmap <leader>rr :!godot4 --path ~/godot/SLG_P2<CR>
" nmap <leader>gg :call <SID>switch_to_godot_then_back_and_execute('MainCover')<CR>
" nmap <leader>gg :term godot4 --verbose --path /home/ryk/godot/p25_test /home/ryk/godot/p25_test/scenes/main.tscn<CR>
nmap <leader>gg :term godot4 --path /home/ryk/godot/p25_test /home/ryk/godot/p25_test/scenes/main.tscn<CR>
nmap <leader>gf :term godot4 --screen 0 -f --path /home/ryk/godot/p25_test /home/ryk/godot/p25_test/scenes/main.tscn<CR>
nmap <leader>gv :term godot4 --verbose --path /home/ryk/godot/p25_test /home/ryk/godot/p25_test/scenes/main.tscn<CR>
nmap <leader>gr :term godot4 --path /home/ryk/godot/SLG_P2 --editor<CR>
nmap <leader>gt :term godot4 --path /home/ryk/godot/SLG_P2 /home/ryk/godot/SLG_P2/temp/MainCover.tscn<CR>
" nmap <leader>gf :call <SID>switch_to_godot_then_back_and_execute('MainCover',"temp",1)<CR>
nmap <leader>rt :term godot4 --headless --path /home/ryk/godot/SLG_P2 -s /home/ryk/godot/SLG_P2/temp/min_test.gd<CR>
nmap <leader>rv :sp /home/ryk/godot/SLG_P2/temp/min_test.gd<CR>
nmap <leader>g1 :call <SID>switch_to_godot_then_back_and_execute('Journey')<CR>
nmap <leader>g2 :call <SID>switch_to_godot_then_back_and_execute('Arena')<CR>
" nmap <leader>gt :call <SID>switch_to_godot_then_back_and_execute('test')<CR>
nmap <leader>gb :call <SID>switch_to_godot_then_back_and_execute('map_builder', "SLG_P2/builders/map")<CR>

nmap <leader>g3 :call <SID>switch_to_godot_then_back_and_execute('test/test_clip')<CR>
nmap <leader>g4 :call <SID>switch_to_godot_then_back_and_execute('main', 'godot_scene_test')<CR>

" nmap <leader>ru :/home/ryk/godot/SLG_P2/temp/min_test.gd<CR>
" nnoremap <leader>ru :call <SID>switch_to_godot_then_back()<CR>
" function! s:switch_to_godot_then_back()
"     let wname = 'Godot Engine'
"     if s:has_window(wname)
"         echom 'has window named "' . wname . '" to switch'
"         let wid = v:windowid
"         call system('wmctrl -a "' . wname . '"')
"         sleep 500m
"         call system('wmctrl -i -a ' . wid)
"     else
"         echom 'no such window, should start godot'
"     endif
" endfunction

" XXX
" seems vim's arg in map can not be empty string: ''
function! s:switch_to_godot_then_back_and_execute(scn, prefix='', full=0)
    let wname = 'Godot Engine'
    let prefix = a:prefix
    if a:prefix == ''
        let prefix = 'SLG_P2/temp'
    endif
    if a:prefix == ''
        let prefix = 'SLG_P2/temp'
    endif
    let pres = split(prefix, '/')
    let dir = pres[0]
    if s:has_window(wname)
        echom 'has window named "' . wname . '" to switch'
        let wid = v:windowid
        call system('wmctrl -a "' . wname . '"')
        sleep 500m
        call system('wmctrl -i -a ' . wid)
        sleep 500m
        " -f full -m maximized --disable-vsync --time-scale 1.0
        if a:full == 0
            exec "term godot4 --screen 0 --path /home/ryk/godot/". dir .  " /home/ryk/godot/" . prefix  ."/". a:scn . ".tscn"
        else
            exec "term godot4 --screen 0 -f --path /home/ryk/godot/". dir . " /home/ryk/godot/" . prefix  ."/" . a:scn . ".tscn"
        endif
    else
        echom 'no such window, should start godot first'
    endif
endfunction

command! -nargs=1 Grun call <SID>switch_to_godot_then_back_and_execute(<f-args>)

nmap <silent><leader>t1 :call <SID>sleep_await(1)<CR>
nmap <silent><leader>t2 :call <SID>sleep_await(3)<CR>
nmap <silent><leader>t3 :call <SID>sleep_await(5)<CR>
nmap <silent><leader>t4 :call <SID>sleep_await(10)<CR>
nmap <silent><leader>t5 :call <SID>sleep_await(20)<CR>
nmap <silent><leader>t6 :call <SID>sleep_await(40)<CR>
let s:timer_id = -1
let s:timer_len = 0
function! s:sleep_await(t)
    " call system('mpc pause')
    if s:timer_id != -1
        call timer_stop(s:timer_id)
        echom 'stopped prev timer'
    endif
    let s:timer_id = timer_start(a:t*1000*60, '<SID>end_sleep')
    let s:timer_len = a:t
    call s:notify('NOTE: started timer of ' . a:t . ' minutes')
endfunction
function s:end_sleep(args)
    let t = 'NOTE: finished the '. s:timer_len . ' minutes timer'
    call s:notify(t)
    let s:timer_id = -1
endfunction
function s:notify(txt)
    " sil! call system('espeak -s 120 "' . a:txt . '"')
    sil! call system('spd-say -r -40 "' . a:txt . '"')
    call popup_notification(a:txt, #{
            \ pos: 'topright',
            \ col: 999,
            \ line: 1,
            \ minWidth: 24,
            \ time: 4000,
            \ })
endfunction

" -----------------------------------------------------------------

