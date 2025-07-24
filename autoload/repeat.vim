" repeat.vim - Let the repeat command repeat plugin maps

" Special function to avoid spurious repeats in a related, naturally repeating
" mapping when your repeatable mapping doesn't increase b:changedtick.
function! repeat#invalidate()
    autocmd! repeat_custom_motion
    let g:repeat_tick = -1
endfunction

function! repeat#set(sequence,...)
    let g:repeat_sequence = a:sequence
    let g:repeat_count = a:0 ? a:1 : v:count
    let g:repeat_tick = b:changedtick
    augroup repeat_custom_motion
        autocmd!
        autocmd CursorMoved <buffer> let g:repeat_tick = b:changedtick | autocmd! repeat_custom_motion
    augroup END
endfunction

function! repeat#setreg(sequence,register)
    let g:repeat_reg = [a:sequence, a:register]
endfunction

function! s:default_register()
    let values = split(&clipboard, ',')
    if index(values, 'unnamedplus') != -1
        return '+'
    elseif index(values, 'unnamed') != -1
        return '*'
    else
        return '"'
    endif
endfunction

function! repeat#run(count)
    let s:errmsg = ''
    try
        if g:repeat_tick == b:changedtick
            let r = ''
            if g:repeat_reg[0] ==# g:repeat_sequence && !empty(g:repeat_reg[1])
                " Take the original register, unless another (non-default, we
                " unfortunately cannot detect no vs. a given default register)
                " register has been supplied to the repeat command (as an
                " explicit override).
                let regname = v:register ==# s:default_register() ? g:repeat_reg[1] : v:register
                if regname ==# '='
                    " This causes a re-evaluation of the expression on repeat, which
                    " is what we want.
                    let r = '"=' . getreg('=', 1) . "\<CR>"
                else
                    let r = '"' . regname
                endif
            endif

            let c = g:repeat_count
            let s = g:repeat_sequence
            let cnt = c == -1 ? "" : (a:count ? a:count : (c ? c : ''))
            call feedkeys(s, 'i')
            call feedkeys(r . cnt, 'ni')
        else
            call feedkeys((a:count ? a:count : '') . '.', 'ni')
        endif
    catch /^Vim(normal):/
        let s:errmsg = v:errmsg
        return 0
    endtry
    return 1
endfunction

function! repeat#errmsg()
    return s:errmsg
endfunction

function! repeat#wrap(command,count)
    let foldopen = &foldopen =~# 'undo\|all' ? 'zv' : ''
    let preserve = g:repeat_tick == b:changedtick ? ":let g:repeat_tick = b:changedtick\r" : ''
    return (a:count ? a:count : '') . a:command . preserve . foldopen
endfunction

" vim:set ft=vim et sw=4 sts=4:
