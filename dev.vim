vim9script

var local = 'local variable is not exported, script-local'

var winid: number
def g:Test(v1: string, v2: string)
    # echo 'testwith ' .. v1 .. v2
	var propId = '123123'

    winid = popup_create("hello\n jfiejfi ajfioej ijwei ", {
        \ 'pos': 'botleft',
        \ 'line': 'cursor-1',
        \ 'col': 2,
        \ 'moved': 'WORD',
        \ })
enddef

map <leader>t1 :call g:Test('eee', 'bbb')<cr>
