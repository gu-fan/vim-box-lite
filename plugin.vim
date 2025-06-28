" vim9script noclear

call plug#begin('~/.vim/plugged')

" HTML
" vim:sw=2
Plug 'wellle/targets.vim'
" Plug 'chemzqm/wxapp.vim'
" Plug 'wavded/vim-stylus'
Plug 'groenewege/vim-less'
Plug 'kchmck/vim-coffee-script'

au BufRead,BufNewFile,BufReadPre *.coffee  set filetype=coffee

Plug 'jparise/vim-graphql'
" Plug 'HerringtonDarkholme/yats.vim'
Plug 'mileszs/ack.vim'

" Plug 'mxw/vim-jsx'
" let g:jsx_ext_required = 1
Plug 'pangloss/vim-javascript'
" Plug 'leafOfTree/vim-vue-plugin'    " it's too slow, though indent is
" provided
" Plug 'posva/vim-vue'
" Plug 'iloginow/vim-stylus'

" let g:vue_pre_processors = ['pug', 'stylus']
" let g:vue_pre_processors = 'detect_on_enter'
" Plug 'leafgarland/typescript-vim'
" Plug 'HerringtonDarkholme/yats.vim'
"
Plug 'dart-lang/dart-vim-plugin'

Plug 'rust-lang/rust.vim'
Plug 'habamax/vim-godot'

Plug 'godlygeek/tabular'
nmap <Leader>== :Tabularize /=<CR>
vmap <Leader>== :Tabularize /=<CR>
nmap <Leader>=, :Tabularize /,<CR>
vmap <Leader>=, :Tabularize /,<CR>
nmap <Leader>=: :Tabularize /:\zs<CR>
vmap <Leader>=: :Tabularize /:\zs<CR>
" setlocal indentkeys+=0.
" make build work better
" autocmd QuickFixCmdPost [^l]* nested cwindow
" autocmd QuickFixCmdPost    l* nested lwindow


" Plug 'maksimr/vim-jsbeautify' , { 'do': 'git submodule update --init --recursive' }
"
" com! -nargs=0 JS call JsBeautify() | setf javascript
" com! -nargs=0 CSS call CSSBeautify() | setf css
" com! -nargs=0 HTML call HtmlBeautify() | setf html
com! -nargs=0 JSON %!python -m json.tool

" 解决js 文件 gf跳转的问题
Plug 'tpope/vim-apathy'
aug au_js "{{{
    au!
aug END "}}}
" nmap gj :echo FindRoot(expand('<cfile>'))<CR>

" fun! CheckValid(path, ext, idx)
"     let path = a:path
"     let ext = a:ext
"     let idx = a:idx
"     " echom path . ext
"     " echom filereadable(path . ext )
"     " echom path . idx
"     " echom filereadable(path . idx )
"     if filereadable(path . ext )
"         return [1, path . ext]
"     elseif filereadable(path . idx)
"         return [2, path . idx]
"     elseif isdirectory(path )
"         return [3, path ]
"     else
"         return [0,0]
"     endif
" endfun
" fun! FindRoot(name)
"     if (a:name =~ '^@' )
"         let path = substitute(a:name,'^@','src','') 
"     else
"         let path = 'node_modules/' . a:name 
"     endif
"     echoe path
" let path = 'node_modules/' . a:name 

"     let ext = '.js'
"     let idx = '/index.js'
"     let i = 0
"     let full = CheckValid(path, ext, idx)
"     echoe full
"     while i < 5
"         let path = '../'. path
"         let i+=1
"         let full = CheckValid(path, ext, idx)

"         if full[0] != 0
"             return full[1]
"         endif
"     endwhile
" endfun

aug au_js "{{{
    au!
    au FileType javascript,vue nmap <silent><buffer> gf :call GoFile(expand('<cfile>'), @%)<CR>
    au FileType javascript,vue nmap <silent><buffer> <A-LeftMouse> :call GoFile(expand('<cfile>'), @%, 'a-l')<CR>
    au FileType javascript,vue nmap <silent><buffer> <c-w>s :call GoFile(expand('<cfile>'), @%, 'sp')<CR>
    au FileType javascript,vue nmap <silent><buffer> <c-w><c-s> :call GoFile(expand('<cfile>'), @%, 'sp')<CR>
    au FileType javascript,vue nmap <silent><buffer> <c-w>v :call GoFile(expand('<cfile>'), @%, 'vs')<CR>
    au FileType javascript,vue nmap <silent><buffer> <c-w><c-v> :call GoFile(expand('<cfile>'), @%, 'vs')<CR>
aug END "}}}

function! GoFile(target, current, ...) abort
  let target = FindFile(a:target, a:current)
  if filereadable(target)
    if a:0
      if a:1 == '2-l'
        exec "e " . target
      else
        exec a:1. " " . target
      endif
    else
      exec "e " . target
    endif
  else
    if a:0
      if a:1 == 'a-l'
        exe "norm! \<A-LeftMouse>"
      else
        exec a:1
      endif
    endif
    echom "Can't find file '" . a:target . "' in path"
  endif
endfunction
" echo match('a require( "test"', includeReg)
" echo match('import xxxx from "aaaa"', includeReg)
function! CheckPathExist(target) 
  let target = a:target
  if filereadable(target)
      return target
  endif
  if isdirectory(target)
    let idx_tar = target . '/index.js'
    if filereadable(idx_tar)
        return idx_tar
    endif
  else
    let suff_tar = target . '.js'
    if filereadable(suff_tar)
        return suff_tar
    endif
  endif
  return ''
endfun
function! FindFile(target, current) abort
  let line = getline(".")
  let includeReg = '\(\<require\s*(\s*[''"]\zs.*\ze[''"]\|import.*\<from\s*[''"]\zs.*\ze[''"]\)'
  if match(line, includeReg) == -1
    return
  endif

  " 保证光标位置在文件名中
  let startReg = '\(\<require\s*(\s*[''"]\zs\|import.*\<from\s*[''"]\zs\)'
  let endReg = '\(\<require\s*(\s*[''"][^''"]*\zs[''"]\|import.*\<from\s*[''"][^''"]*\zs[''"]\)'
  let start = match(line, startReg)
  let end = match(line, endReg)
  let col = getpos('.')[2]
  if col < start || col > end
    return
  endif


  let target = substitute(a:target, '^\~[^/]\@=', '', '')
  let target = substitute(target, '^@[/]\@=', '', '')
  if target =~# '^\.\.\=/'
    let target = simplify(fnamemodify(resolve(a:current), ':p:h') . '/' . target)
  endif

  " check if it's dir or file
  " xxxx/xxxx
  let _tar = CheckPathExist(target)
  if len(_tar)
    return _tar
  endif


  " check if it's package in node_modules
  " package.json-/node_modules/xxx/xxxx
  let path = split(&path, ',')[0]
  let node_dir = path . '/' . target 
  if isdirectory(node_dir)
    let pkg_file = node_dir.'/package.json'
     if filereadable(node_dir.'/package.json')
      try
        let package = json_decode(join(readfile(pkg_file)))
        let target = node_dir . '/' . get(package, 'main', 'index.js')
      catch
      endtry
     endif
  endif

  " we may should check it's in NODE_PATH

  " check if its based in project root
  " root/xxxx/xxxx
  let root_dir = fnamemodify(path, ':p:h:h')
  let root_path = root_dir . '/' . target
  let _tar = CheckPathExist(root_path)
  if len(_tar)
    return _tar
  endif


  " check if it's in the 
  " root/src/xxxx/xxxx
  let roo_src_path = root_dir . '/src/' . target
  let _tar = CheckPathExist(roo_src_path)
  if len(_tar)
    return _tar
  endif

  echom target




  return target
endfunction





Plug 'mattn/emmet-vim'

let g:user_emmet_settings       = { 
    \ 'indentation' : '  ',
    \ 'vue': {
    \ 'extends' : 'html'
    \}}
let g:user_emmet_leader_key     = '<c-f>'
let g:user_emmet_expandabbr_key = '<c-f>f'    "e
let g:user_emmet_expandword_key = '<c-f>F'    "e
let g:user_emmet_next_key       = '<c-f>j'    "n
let g:user_emmet_prev_key       = '<c-f>k'    "p
let g:user_emmet_removetag_key  = '<c-f>d'    "k




aug au_emmet_vue
    au!
    " au BufRead,BufNewFile *.vue setf vue
    " autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css.scss
    autocmd BufRead,BufNewFile *.vue setlocal filetype=vue
    " autocmd BufRead,BufNewFile *.vue setlocal includeexpr=LoadMainNodeModule(v:fname)
    
    " au FileType vue imap <tab> <plug>(emmet-expand-abbr)
au FileType vue setl sw=2
au BufNewFile,BufRead *.html,*.js,*.vue set tabstop=2
au BufNewFile,BufRead *.html,*.js,*.vue set softtabstop=2
au BufNewFile,BufRead *.html,*.js,*.vue set shiftwidth=2
au BufNewFile,BufRead *.html,*.js,*.vue set expandtab
au BufNewFile,BufRead *.html,*.js,*.vue set autoindent
au BufNewFile,BufRead *.html,*.js,*.vue set fileformat=unix
autocmd FileType vue syntax sync fromstart 
au BufNewFile,BufRead *.styl set syntax=less
aug END





Plug 'cakebaker/scss-syntax.vim'
au BufRead,BufNewFile *.scss set filetype=scss.css
au FileType scss set iskeyword+=-


Plug 'maksimr/vim-jsbeautify' , { 'do': 'git submodule update --init --recursive' }


" Plug 'AndrewRadev/inline_edit.vim'
"     " normal mode:
"     nnoremap <leader>ee :InlineEdit<cr>

"     " visual mode:
"     xnoremap <leader>ee :InlineEdit<cr>

"     " insert mode:
"     inoremap <c-e>e <esc>:InlineEdit<cr>a

" complete
"

" Plug 'Shougo/neocomplcache'
" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   Plug 'Shougo/deoplete.nvim'
"   Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'
" endif
" let g:deoplete#enable_at_startup = 1

" inoremap <silent><expr> <TAB>
" \ pumvisible() ? "\<C-n>" :
" \ <SID>check_back_space() ? "\<TAB>" :
" \ deoplete#manual_complete()
" function! s:check_back_space() abort "{{{
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~ '\s'
" endfunction "}}}


" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" set signcolumn=yes
" inoremap <silent><expr> <TAB>
"       \ coc#pum#visible() ? coc#pum#next(1) :
"       \ CheckBackspace() ? "\<Tab>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" function! CheckBackspace() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" " Use <c-space> to trigger completion
" if has('nvim')
"   inoremap <silent><expr> <c-space> coc#refresh()
" else
"   inoremap <silent><expr> <c-@> coc#refresh()
" endif

" " Use `[g` and `]g` to navigate diagnostics
" " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)

" " GoTo code navigation
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" " Use K to show documentation in preview window
" nnoremap <silent> K :call ShowDocumentation()<CR>

" " Applying code actions to the selected code block
" " Example: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

" " Remap keys for applying code actions at the cursor position
" nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" " Remap keys for apply code actions affect whole buffer
" nmap <leader>as  <Plug>(coc-codeaction-source)
" " Apply the most preferred quickfix action to fix diagnostic on the current line
" nmap <leader>qf  <Plug>(coc-fix-current)

" " Remap keys for applying refactor code actions
" nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
" xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
" nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction
" set shortmess+=c
" set updatetime=300

" ----------------------------------
" Plug 'Konfekt/complete-common-words.vim'
" let s:dotfiles = split(&runtimepath, ',')[0]
" let g:common_words_dicts_dir = s:dotfiles . '/plugged/complete-common-words.vim/dicts'
" unlet s:dotfiles
" set complete+=k
" set dictionary+=spell

Plug 'lifepillar/vim-mucomplete'
set completeopt+=menuone
set completeopt+=noselect
set completeopt-=preview
set completeopt+=popup
set shortmess+=c   " Shut off completion messages
let g:mucomplete#enable_auto_at_startup = 1
imap <expr> <down> mucomplete#extend_fwd("\<down>")
let g:mucomelete#always_use_completeopt=  1


set complete+=i

" let g:mucomplete#chains = {}
" let g:mucomplete#chains.default = ['path', 'nsnp', 'keyn', "c-n", "dict"]

" ----------------------------------
" inoremap <silent> <expr> <plug><MyCR>
"     \ mucomplete#neosnippet#expand_snippet("\<cr>")
" imap <cr> <plug><MyCR>

" Plug 'ajh17/VimCompletesMe'
" Plug 'Shougo/ddc.vim'
" call ddc#custom#patch_global('sources', ['around'])

" " Use matcher_head and sorter_rank.
" " https://github.com/Shougo/ddc-matcher_head
" " https://github.com/Shougo/ddc-sorter_rank
" call ddc#custom#patch_global('sourceOptions', {
"       \ '_': {
"       \   'matchers': ['matcher_head'],
"       \   'sorters': ['sorter_rank']},
"       \ })

" " Change source options
" call ddc#custom#patch_global('sourceOptions', {
"       \ 'around': {'mark': 'A'},
"       \ })
" call ddc#custom#patch_global('sourceParams', {
"       \ 'around': {'maxSize': 500},
"       \ })

" " Customize settings on a filetype
" call ddc#custom#patch_filetype(['c', 'cpp'], 'sources', ['around', 'clangd'])
" call ddc#custom#patch_filetype(['c', 'cpp'], 'sourceOptions', {
"       \ 'clangd': {'mark': 'C'},
"       \ })
" call ddc#custom#patch_filetype('markdown', 'sourceParams', {
"       \ 'around': {'maxSize': 100},
"       \ })

" " Mappings

" " <TAB>: completion.
" inoremap <silent><expr> <TAB>
" \ ddc#map#pum_visible() ? '<C-n>' :
" \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
" \ '<TAB>' : ddc#map#manual_complete()

" " <S-TAB>: completion back.
" inoremap <expr><S-TAB>  ddc#map#pum_visible() ? '<C-p>' : '<C-h>'

" " Use ddc.
" call ddc#enable()

Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
" Plug 'honza/vim-snippets'

"" Neocomplcache "{{{2
"nno <leader>nt :NeoComplCacheToggle<CR>
"nno <leader>nb :NeoComplCacheCachingBuffer<CR>
"let g:acp_enableAtStartup                      = 0
"let g:neocomplcache_enable_at_startup          = 1
"let g:neocomplcache_enable_smart_case          = 1
"let g:neocomplcache_enable_camel_case_completion = 1
"let g:neocomplcache_enable_ignore_case         = 0
"" Use underbar completion.
"let g:neocomplcache_enable_underbar_completion = 1
"let g:neocomplcache_min_syntax_length          = 2
"let g:neocomplcache_lock_buffer_name_pattern   = '\*ku\*'

"" Define dictionary.
"let g:neocomplcache_dictionary_filetype_lists = {
"            \ 'default' : '',
"            \ 'vimshell' : $HOME.'/.vimshell_hist',
"            \ 'scheme' : $HOME.'/.gosh_completions'
"            \ }
"" Define keyword.
"if !exists('g:neocomplcache_keyword_patterns')
"    let g:neocomplcache_keyword_patterns = {}
"endif
"let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

"" let g:neocomplcache_disable_caching_file_path_pattern="fuf"
"" let g:neocomplcache_quick_match_patterns={'default':'`'}
"" let g:neocomplcache_quick_match_table = {
""             \'1' : 0, '2' : 1, '3' : 2, '4' : 3, '5' : 4, '6' : 5, '7' : 6, '8' : 7, '9' : 8, '0' : 9,
""             \}

"if exists("*neocomplcache#smart_close_popup")
"    ino <expr><C-h>   neocomplcache#smart_close_popup()."\<left>"
"    ino <expr><C-l>   neocomplcache#smart_close_popup()."\<right>"
"    ino <expr><Space> neocomplcache#smart_close_popup()."\<Space>"
"    ino <expr><CR>    neocomplcache#smart_close_popup()."\<CR>"
"    ino <expr><BS>    neocomplcache#smart_close_popup()."\<BS>"
"    ino <expr><C-y>   neocomplcache#close_popup()
"endif

""{{{ omni comp
"aug neocomp_omni_compl "{{{
"    au! neocomp_omni_compl
"    " Enable omni completion.
"    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
"aug END "}}}
"" Enable heavy omni completion.
"if !exists('g:neocomplcache_omni_patterns')
"    let g:neocomplcache_omni_patterns = {}
"endif
"let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
""autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
"let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
"let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
""}}}

" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   Plug 'Shougo/deoplete.nvim'
"   Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'
" endif
"
" let g:deoplete#enable_at_startup = 1
" "
" "
"
 " deoplete options
 " let g:deoplete#enable_smart_case = 1

"call deoplete#custom#option({
"\ 'auto_complete_delay': 200,
"\ 'smart_case': v:true,
"\ })
" " disable autocomplete by default
" let b:deoplete_disable_auto_complete=1 
" let g:deoplete_disable_auto_complete=1
" call deoplete#custom#buffer_option('auto_complete', v:false)

" if !exists('g:deoplete#omni#input_patterns')
"     " let g:deoplete#omni#input_patterns = {}
"		call deoplete#custom#var('omni', 'input_patterns', {
"		    \ 'java': '[^. *\t]\.\w*',
"		    \ 'php': '\w+|[^. \t]->\w*|\w+::\w*',
"		    \})
" endif

" " Disable the candidates in Comment/String syntaxes.
" call deoplete#custom#option('_',
"             \ 'disabled_syntaxes', ['Comment', 'String'])

" autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" " set sources
"call deoplete#custom#option('sources', {
"\ '_': ['buffer'],
"\ 'cpp': ['buffer', 'tag'],
"\})
" " let g:deoplete#sources = {}
" " let g:deoplete#sources.cpp = ['LanguageClient']
" " let g:deoplete#sources.python = ['LanguageClient']
" " let g:deoplete#sources.python3 = ['LanguageClient']
" " let g:deoplete#sources.rust = ['LanguageClient']
" " let g:deoplete#sources.c = ['LanguageClient']
" " let g:deoplete#sources.vim = ['vim']
" "
" Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }

" let g:deoplete#sources#ternjs#tern_bin = '/usr/local/bin/tern'
" let g:deoplete#sources#ternjs#timeout = 1

" " Whether to include the types of the completions in the result data. Default: 0
" let g:deoplete#sources#ternjs#types = 0

" " Whether to include the distance (in scopes for variables, in prototypes for 
" " properties) between the completions and the origin position in the result 
" " data. Default: 0
" let g:deoplete#sources#ternjs#depths = 1

" " Whether to include documentation strings (if found) in the result data.
" " Default: 0
" let g:deoplete#sources#ternjs#docs = 0

" " When on, only completions that match the current word at the given point will
" " be returned. Turn this off to get all results, so that you can filter on the 
" " client side. Default: 1
" let g:deoplete#sources#ternjs#filter = 0

" " Whether to use a case-insensitive compare between the current word and 
" " potential completions. Default 0
" let g:deoplete#sources#ternjs#case_insensitive = 1

" " When completing a property and no completions are found, Tern will use some 
" " heuristics to try and return some properties anyway. Set this to 0 to 
" " turn that off. Default: 1
" let g:deoplete#sources#ternjs#guess = 0

" " Determines whether the result set will be sorted. Default: 1
" let g:deoplete#sources#ternjs#sort = 0

" " When disabled, only the text before the given position is considered part of 
" " the word. When enabled (the default), the whole variable name that the cursor
" " is on will be included. Default: 1
" let g:deoplete#sources#ternjs#expand_word_forward = 0

" " Whether to ignore the properties of Object.prototype unless they have been 
" " spelled out by at least two characters. Default: 1
" let g:deoplete#sources#ternjs#omit_object_prototype = 0

" " Whether to include JavaScript keywords when completing something that is not 
" " a property. Default: 0
" let g:deoplete#sources#ternjs#include_keywords = 1

" " If completions should be returned when inside a literal. Default: 1
" let g:deoplete#sources#ternjs#in_literal = 0


" "Add extra filetypes
" let g:deoplete#sources#ternjs#filetypes = [
"                 \ 'jsx',
"                 \ 'javascript.jsx',
"                 \ 'vue',
"                 \ ]
""


" neocompl cache snippets_complete
nmap <c-k> a<c-k><esc>
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
" ino <expr>.   pumvisible() ? "." : "."
" ino <expr><TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
" ino <expr><s-TAB> pumvisible() ? "\<C-p>" : "\<s-TAB>"
" SuperTab like snippets behavior.
" imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
" \ "\<Plug>(neosnippet_expand_or_jump)"
" \: pumvisible() ? "\<C-n>" : "\<TAB>"
" smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
" \ "\<Plug>(neosnippet_expand_or_jump)"
" \: "\<TAB>"
"
" inoremap <silent><expr> <TAB>
" \ pumvisible() ? "\<C-n>" :
" \ <SID>check_back_space() ? "\<TAB>" :
" \ deoplete#manual_complete()
" function! s:check_back_space() abort "{{{
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~ '\s'
" endfunction "}}}
"

" For snippet_complete marker.
if has('conceal')
    set conceallevel=0 concealcursor=i
endif
let g:neosnippet#snippets_directory = "~/.vim-box/snips/snippets_complete/"
let g:neosnippet#enable_snipmate_compatibility = 1

map <leader>pe :sp\|NeoSnippetEdit<cr>
map <leader>pr :sp\|NeoSnippetSource<cr>
map <leader>p_ :sp\|e ~/.vim-box/snips/snippets_complete/_.snip <cr>

command! EditSnip sp|NeoSnippetEdit
command! EditSrc sp|NeoSnippetSource
command! EditMy sp|e ~/.vim-box/snips/snippets_complete/_.snip


" Deprecated, not good as neosnippet
" Plug 'vim-scripts/UltiSnips'
" Plug 'tomtom/tcomment_vim'
" let g:tcommentMapLeaderOp1 = '<leader>c'
" nnoremap <c-/> :TComment<cr>
" let g:tcommentGuessFileType = 0
" let g:tcommentGuessFileType_vue = 'html'
"
Plug 'tpope/vim-commentary'
Plug 'suy/vim-context-commentstring'

nno <leader>cc :Commentary<CR>
vno <leader>cc :Commentary<CR>
" vno <leader>c :Commentary<CR>
vno <leader>c <Nop>

Plug 'tpope/vim-surround'
" Plug 'tpope/vim-repeat'
" Plug 'tpope/vim-abolish'

" document
" Plug 'gu-fan/simpletodo.vim'
Plug 'gu-fan/riv.vim'

let proj1 = {'path': '~/Documents/wikis/wiki_new/'}
let proj2 = {'path': '~/Documents/wikis/riv/'}

let g:riv_projects = [proj1, proj2]
" XXX: This should be set as a project option.
let g:riv_todo_datestamp = 0
let g:riv_file_link_style = 2
let g:riv_file_link_ext ="vim,py,rb,js,css,vue,yml,json,html,htm,gd"
let g:riv_web_browser = "google chrome"
let g:riv_todo_levels = " ,x"

Plug 'gu-fan/autotype.vim'
" Plug 'rykka/os.vim'
" Plug 'rykka/clickable.vim'
" let g:clickable_browser = 'google chrome'
" Plug 'rykka/clickable-things'
" Plug 'rykka/autotype.vim'
Plug 'gu-fan/InstantRst'

" Plug 'vim-jp/vital.vim'

Plug 'mattn/webapi-vim'
" Plug 'rykka/trans.vim'

" " This api is much faster.
" " let g:trans_default_api = 'google'
" let g:trans_map_trans = '<localleader>tt'
"
noremap <leader>tt :call <SID>trans()<CR>
func! s:trans()
    " exec '!trans -b -t zh+en ' . expand('<cword>')
    " exec '!dict -d wn '. expand('<cword>')
    exec '!sdcv -n '. expand('<cword>')
endfunc

Plug 'mhinz/vim-startify'
let g:startify_session_autoload    = 1
let g:startify_session_persistence = 1
let g:startify_relative_path       = 1
let g:startify_change_to_dir       = 1
noremap <c-e>ss :Startify<CR>
noremap <leader>ss :Startify<CR>
" let g:startify_session_before_save = [ 'silent! tabdo NERDTreeClose' ]
let g:startify_lists = [
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]

let g:startify_skiplist = [
        \ 'COMMIT_EDITMSG',
        \ 'bundle/.*/doc',
        \ '/data/repo/neovim/runtime/doc',
        \ '/Users/mhi/local/vim/share/vim/vim74/doc',
        \ ]

hi StartifyBracket ctermfg=240
hi StartifyFile    ctermfg=147
hi StartifyFooter  ctermfg=240
hi StartifyHeader  ctermfg=114
hi StartifyNumber  ctermfg=215
hi StartifyPath    ctermfg=245
hi StartifySlash   ctermfg=240
hi StartifySpecial ctermfg=240



" filemanager
"
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'


" popup window for search word and preview real time
noremap <leader>h :Ag<CR>
" noremap <c-h> :Ag<CR>

" Plug 'gu-fan/duonote.vim'

Plug 'scrooloose/nerdtree'


" Plug 'lambdalisue/fern.vim'

let g:NERDTreeQuitOnOpen=0
let g:NERDTreeShowHidden=1
let g:NERDTreeMinimalUI=1
let g:NERDTreeShowBookmarks = 0
let g:NERDTreeWinPos = 'left'
let g:NERDTreeWinSize = 20
let g:NERDTreeHijackNetrw=0         
" netrw 还是有很多问题，双击会返回上级
" nerd too
let g:netrw_mousemaps= 0
let NERDTreeIgnore=['\~$', '.meta$[[file]]', '.uid', '.DS_Store', '.import']

aug au_NERD
    au!
    au filetype netrw nmap <buffer> <2-leftmouse> <CR>
    " NERDTREE AUTO REFRESH
    " au BufWritePost * 
    "     \ if type(g:NERDTree.ForCurrentTab()) != 0 |
    "     \ call g:NERDTree.ForCurrentTab().getRoot().refresh() |
    "     \ endif
aug END

Plug 'tpope/vim-vinegar'
" Plug 'justinmk/vim-dirvish'
" Plug 'lambdalisue/fern.vim'

Plug 'kien/ctrlp.vim'
" nmap <C-J>  :CtrlPLine<CR>
let g:ctrlp_custom_ignore =  {
    \ 'dir':  '\v[\/](\.(git|hg|svn)|node_modules|dist|backup|.import|Shared|Downloads)$',
    \ 'file': '\v\.(exe|so|dll|meta|png|jpg|psd|asset|ttf|otf|import|aseprite|ase|uid)$',
    \ }
let g:ctrlp_use_cache = 1
let g:ctrlp_root_markers=['.git', 'package.json', 'package.vim','.root', 'project.godot']
let g:ctrlp_switch_buffer = 'v'
let g:ctrlp_prompt_mappings = { 'PrtClearCache()': ['<F5>', '<m-5>'] }
let g:ctrlp_user_command = 'ag %s -l --nocolor --ignore={".git/","addons/","*.png","*.aseprite","*.uid","*.import"} --hidden -g ""'
" let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/node_modules/*,.DS_Store,default-0.json,*.png,*.aseprite,*.uid,*.import

let g:ctrlp_max_depth = 10
let g:ctrlp_max_files = 2000

" let g:ctrlp_working_path_mode = 'wr'
" fun! V(...)
"     CtrlPMRU
"     if a:0
"         call feedkeys(a:1)
"     endif
" endfun
" com! -nargs=* V call V(<q-args>)
" let g:ctrlp_cmd = 'CtrlPMixed'
" nmap <c-p>  :CtrlPMixed<CR>
nmap <leader>el  :CtrlPLine<CR>

" map <leader>pp  :CtrlP<CR>

" Plug 'Shougo/denite.nvim'

" call denite#custom#option('default', 'prompt', '> ')
" "call denite#custom#option('default', 'direction', 'bottom')
" call denite#custom#option('default', 'empty', 0)
" call denite#custom#option('default', 'auto_resize', 1)
" call denite#custom#option('default', 'auto_resume', 1)
" call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
"   \ [ '.git/', '.ropeproject/', '__pycache__/', '*.min.*', 'fonts/'])
" " Change file_rec command.
" call denite#custom#var('file_rec', 'command',
"   \ ['rg', '--color', 'never', '--files'])
" " buffer
" call denite#custom#var('buffer', 'date_format', '')
" call denite#custom#source('buffer', 'matchers', ['matcher/fuzzy', 'matcher/project_files'])
" " Change grep options.
" call denite#custom#var('grep', 'command', ['rg'])
" call denite#custom#var('grep', 'default_opts',
"     \ ['--vimgrep', '--no-follow'])
" call denite#custom#var('grep', 'recursive_opts', [])
" call denite#custom#var('grep', 'pattern_opt', [])
" call denite#custom#var('grep', 'separator', ['--'])
" call denite#custom#var('grep', 'final_opts', [])
" " Change file_rec matcher
" call denite#custom#source('line', 'matchers', ['matcher_regexp'])
" call denite#custom#source('file_rec, redis_mru', 'sorters', ['sorter/sublime'])
"
"
" " Change mappings.
" call denite#custom#map(
"       \ 'insert',
"       \ '<C-a>',
"       \ '<denite:move_caret_to_head>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'insert',
"       \ '<C-j>',
"       \ '<denite:move_to_next_line>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'insert',
"       \ '<C-k>',
"       \ '<denite:move_to_previous_line>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'insert',
"       \ '<C-s>',
"       \ '<denite:do_action:vsplit>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'insert',
"       \ '<C-t>',
"       \ '<denite:do_action:tabopen>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'insert',
"       \ '<C-d>',
"       \ '<denite:do_action:delete>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'insert',
"       \ '<C-b>',
"       \ '<denite:scroll_page_backwards>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'insert',
"       \ '<C-f>',
"       \ '<denite:scroll_page_forwards>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'insert',
"       \ '<C-p>',
"       \ '<denite:print_messages>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'normal',
"       \ '<C-j>',
"       \ '<denite:wincmd:j>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'normal',
"       \ '<C-k>',
"       \ '<denite:wincmd:k>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'normal',
"       \ '<esc>',
"       \ '<denite:quit>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'normal',
"       \ 'a',
"       \ '<denite:do_action:add>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'normal',
"       \ 'd',
"       \ '<denite:do_action:delete>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'normal',
"       \ 'r',
"       \ '<denite:do_action:reset>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'normal',
"       \ 's',
"       \ '<denite:do_action:vsplit>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'normal',
"       \ 'e',
"       \ '<denite:do_action:edit>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'normal',
"       \ 'h',
"       \ '<denite:do_action:help>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'normal',
"       \ 'u',
"       \ '<denite:do_action:update>',
"       \ 'noremap'
"       \)
"
" call denite#custom#map(
"       \ 'normal',
"       \ 'f',
"       \ '<denite:do_action:find>',
"       \ 'noremap'
"       \)

" Plug 'cocopon/vaffle.vim'

" Plug 'vim-denops/denops.vim'
" Plug 'Shougo/ddu.vim'
" Plug 'Shougo/ddu-filer.vim'
" call ddu#custom#patch_global({
"     \   'ui': 'filer',
"     \   'actionOptions': {
"     \     'narrow': {
"     \       'quit': v:false,
"     \     },
"     \   },
"     \ })
" Plug 'Shougo/ddu-commands.vim'
" " Use file_rec source.
" Ddu file_rec

" " Change input option
" Ddu file -input=foo

" " Use ui param
" Ddu file -ui-param-startFilter=v:true

" You must set the default ui.
" Note: ff ui
" https://github.com/Shougo/ddu-ui-ff
" call ddu#custom#patch_global({
"     \ 'ui': 'ff',
"     \ })

" " You must set the default action.
" " Note: file kind
" " https://github.com/Shougo/ddu-kind-file
" call ddu#custom#patch_global({
"     \   'kindOptions': {
"     \     'file': {
"     \       'defaultAction': 'open',
"     \     },
"     \   }
"     \ })

" " Specify matcher.
" " Note: matcher_substring filter
" " https://github.com/Shougo/ddu-filter-matcher_substring
" call ddu#custom#patch_global({
"     \   'sourceOptions': {
"     \     '_': {
"     \       'matchers': ['matcher_substring'],
"     \     },
"     \   }
"     \ })

" Set default sources
" Note: file source
" https://github.com/Shougo/ddu-source-file
"call ddu#custom#patch_global({
"    \ 'sources': [{'name': 'file', 'params': {}}],
"    \ })

" Call default sources
"call ddu#start({})

" Set name specific configuration
"call ddu#custom#patch_local('files', {
"    \ 'sources': [
"    \   {'name': 'file', 'params': {}},
"    \   {'name': 'file_old', 'params': {}},
"    \ ],
"    \ })

" Specify name
"call ddu#start({'name': 'files'})

" Specify source with params
" Note: file_rec source
" https://github.com/Shougo/ddu-source-file_rec
"call ddu#start({'sources': [
"    \ {'name': 'file_rec', 'params': {'path': expand('~')}}
"    \ ]})


" git 
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

nnore <Leader>gp :Git push<CR>
nnore <Leader>gP :Git pull<CR>
" nnore <Leader>gp :Srun git push<CR>
" nnore <Leader>gP :Srun git pull<CR>
nnore <leader>gc :Git commit -a -v<CR>
nnore <leader>gs :Git<CR>
nnore <leader>gb :Git blame<CR>

Plug 'airblade/vim-gitgutter'

Plug 'Shougo/echodoc'
" Plug 'skywind3000/asyncrun.vim'
" command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" Plug 'chemzqm/vim-easygit'
" Plug 'chemzqm/denite-git'

" Plug 'kopischke/vim-stay'
" history
"

Plug 'sjl/gundo.vim'

" Open Last closed window
Plug 'gu-fan/lastbuf.vim'

" use startify session instead
" save/load last workspace
Plug 'tpope/vim-obsession'

set ssop=blank,curdir,help,resize,tabpages,winsize,winpos,terminal

let _p = expand('~/.vim/session')
if !isdirectory(_p)
    call mkdir(_p, 'p')
endif

fun! s:save_session(ses)
    if a:ses != ''
        exe 'Obsession ~/.vim/session/' . a:ses . '.vim'
    else
        Obsession ~/.vim/session/default.vim
    endif
endfun

fun! s:load_session(ses)
    if a:ses != ''
        exe 'so ~/.vim/session/' . a:ses . '.vim'
    else
        so ~/.vim/session/default.vim
    endif
endfun

fun! s:del_session(ses)
    if a:ses != ''
        exe '!rm ~/.vim/session/' . a:ses . '.vim'
    else
        echom 'can not remove default session'
    endif
endfun

fun! s:restart()
    Obsession ~/.vim/session/restart.vim
    execute 'wa'
    call system('gvim -c "SLoad restart"')
    quitall
endfun

com! -nargs=? -complete=customlist,ListSess Save call s:save_session(<q-args>)
com! -nargs=? -complete=customlist,ListSess Load call s:load_session(<q-args>)
com! -nargs=? -complete=customlist,ListSess Delete call s:del_session(<q-args>)
com! -nargs=0 Restart :call s:restart()
com! -nargs=0 Quit :quitall!

func! ListSess(A,L,P)
    let _ls  = split(globpath('~/.vim/session/', '*'), "\n")
    let _ls = map(_ls, "fnamemodify(v:val, ':t')")
    return _ls
endfun

" cabbrev save Save
" cabbrev load Load
" cabbrev restart Restart

" lang


" mapping

Plug 'Lokaltog/vim-easymotion'
let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
" map <Leader> <Plug>(easymotion-prefix)
let g:EasyMotion_do_mapping = 0
map <Leader> <Nop>
" Gif config
"
nmap f <Plug>(easymotion-s)
nmap F <Plug>(easymotion-s)
nmap t <Plug>(easymotion-t)
nmap s <Plug>(easymotion-s2)
" " Gif config
" map  / <Plug>(easymotion-sn)
" omap / <Plug>(easymotion-tn)

" " These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" " Without these mappings, `n` & `N` works fine. (These mappings just provide
" " different highlight method and have some other features )
" map  n <Plug>(easymotion-next)
" map  N <Plug>(easymotion-prev)

" nmap s <Plug>(easymotion-s)
" Bidirectional & within line 't' motion
omap t <Plug>(easymotion-bd-tl)
" Use uppercase target labels and type as a lower case
let g:EasyMotion_use_upper = 1
 " type `l` and match `l`&`L`
let g:EasyMotion_smartcase = 1
" Smartsign (type `3` and match `3`&`#`)
let g:EasyMotion_use_smartsign_us = 1



Plug 'tommcdo/vim-lion'

com! -nargs=0 Align :norm glip=
com! -nargs=0 Al2 :norm gLip=


" XXX: 太慢了,使用Rime
" " " vim 输入法切换
" Plug 'rlue/vim-barbaric'
" " The IME to invoke for managing input languages (macos, fcitx, ibus, xkb-switch)
" let g:barbaric_ime = 'macos'

" " The input method for Normal mode (as defined by `xkbswitch -g`, `ibus engine`, or `xkb-switch -p`)
" let g:barbaric_default = 1

" " The scope where alternate input methods persist (buffer, window, tab, global)
" let g:barbaric_scope = 'buffer'

" " Forget alternate input method after n seconds in Normal mode (disabled by default)
" " Useful if you only need IM persistence for short bursts of active work.
" let g:barbaric_timeout = -1

"" The fcitx-remote binary (to distinguish between fcitx and fcitx5)
"" let g:barbaric_fcitx_cmd = 'fcitx5-remote'

"" The xkb-switch library path (for Linux xkb-switch users ONLY)
"" let g:barbaric_libxkbswitch = $HOME . '/.local/lib/libxkbswitch.so'
""
"" Plug 'ybian/smartim'

"" let g:smartim_default='com.apple.keylayout.ABC'
"inoremap <c-c> <esc>
" shell
"
" Plug 'Shougo/deol.nvim'

" Plug 'gu-fan/simpleterm.vim'

" nnore <Leader>fk :20Sadd fortune\|cowsay\|lolcat<CR>

" " set shell=/bin/zsh                      " set other shell if needed
" " set shell=/usr/local/bin/fish             " set other shell if needed


" " not useful as not binded
" " set ssop+=terminal

" tnor <leader>pp <c-w>"+

" nnor <leader>pp :call simpleterm.exe()<CR>

" UI
Plug 'gu-fan/colorv.vim'

let g:colorv_preview_ftype = 'css,html,vue,gdscript,javascript,less,styl'

Plug 'gu-fan/galaxy.vim'
Plug 'itchyny/lightline.vim'
" Plug 'github/copilot.vim'
" imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
" let g:copilot_no_tab_map = v:true
" imap <silent><script><expr> <M-J> <Plug>(copilot-next)
"
Plug 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" ColorScheme
Plug 'tomasr/molokai'
Plug 'davidklsn/vim-sialoquent'
Plug 'beikome/cosme.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'morhetz/gruvbox'
Plug 'sainnhe/sonokai'
Plug 'ghifarit53/tokyonight-vim'
Plug 'catppuccin/vim'
Plug 'pineapplegiant/spaceduck'
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'haishanh/night-owl.vim'
Plug 'cocopon/iceberg.vim'
Plug 'navarasu/onedark.nvim'

" -------------------------------------------
" Plug 'prabirshrestha/vim-lsp'
" Plug 'mattn/vim-lsp-settings'

        " \ 'cmd': ["nc", "localhost", "6005"],
" let g:lsp_auto_enable = 0
" com! -nargs=0 LspStart call lsp#enable()
" com! -nargs=0 LspStop call lsp#disable()
" com! -nargs=0 LspGodot call LspSetupGodotServer
" function! LspSetupGodotServer() abort
"         call lsp#register_server({
"         \ 'name': 'godot',
"         \ 'tcp': {server_info->['tcp', '127.0.0.1:6005']},
"         \ 'root_uri':{server_info->lsp#utils#path_to_uri(
"         \        lsp#utils#get_buffer_path(),
"         \        ['godot.project', '.git/']
"         \    )},
"         \ 'allowlist': ['gdscript3', 'gdscript']
"         \ })
" endfunction
" au User lsp_setup 
"         \ call lsp#register_server({
"         \ 'name': 'godot',
"         \ 'tcp': {server_info->['tcp', '127.0.0.1:6005']},
"         \ 'root_uri':{server_info->lsp#utils#path_to_uri(
"         \        lsp#utils#get_buffer_path(),
"         \        ['godot.project', '.git/']
"         \    )},
"         \ 'allowlist': ['gdscript3', 'gdscript']
"         \ })

" nmap gh :LspHover<CR>
" nmap gk :LspPeekDeclaration<CR>
" nmap gn :LspNextDiagnostic<CR>
" nmap gp :LspPreviousDiagnostic<CR>
" nnoremap <expr>gsu lsp#scroll(+4)
" nnoremap <expr>gsd lsp#scroll(-4)
"
" Plug 'thaerkh/vim-workspace'
" let g:workspace_autocreate = 1
" nnoremap <leader>tt :ToggleWorkspace<CR>
" let g:workspace_session_directory = $HOME . '/.vim/sessions/'
"
" Plug 'yegappan/lsp'
" let lspOpts = #{autoHighlightDiags: v:true}
" autocmd User LspSetup call LspOptionsSet(lspOpts)

" let lspServers = [#{
" 	\	  name: 'clang',
" 	\	  filetype: ['c', 'cpp'],
" 	\	  path: '/usr/local/bin/clangd',
" 	\	  args: ['--background-index']
" 	\ }]
" autocmd User LspSetup call LspAddServer(lspServers)


" Plug 'junegunn/limelight.vim'

Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
set timeoutlen=500

" Plug 'dense-analysis/ale'
" let g:ale_fixers = {
" \   'gdscript': ['gdlint'],
" \}
" Plug 'maxbrunsfeld/vim-yankstack'
"


" Plug 'prabirshrestha/vim-lsp'

if has("nvim")
    " Plug 'stevearc/dressing.nvim'
  Plug 'folke/noice.nvim'
  Plug 'MunifTanjim/nui.nvim'
  " Plug 'williamboman/mason.nvim'
  " Plug 'mfussenegger/nvim-lint'
  " Plug "rshkarin/mason-nvim-lint"
  Plug 'nvzone/volt'
  " Plug 'nvzone/timerly' , {'on': ['TimerlyToggle']}
  Plug 'nvzone/timerly'
endif


Plug '~/vim/moon'

call plug#end()

if has("nvim")
    lua require("noice").setup()
    " lua require("mason").setup()
    " lua require("lint").setup()
    " lua require("mason-nvim-lint").setup()
    
    " luafile ~/.vim-box/user.lua

    " au BufWritePost * lua require('lint').try_lint()
endif

" let g:ale_lint_on_enter = 0
" let g:ale_lint_on_save = 1
" nmap <silent> <leader>nn <Plug>(ale_next_wrap)

