
nnoremap <silent><leader>gg :call RunCurrentGodot()<CR>
func! RunCurrentGodot()
    let path = FindProjectRoot('project.godot')
    if path isnot 0
        exec 'term godot4 --resolution 900x480 --position 300,300 -t --path ' . path
    else
        echom 'RunGodot: Not in godot project directory!'
    end
endfun!
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
