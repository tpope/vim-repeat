if exists("g:loaded_repeat") || &cp || v:version < 700
    finish
endif
let g:loaded_repeat = 1


nnoremap <silent> <Plug>(RepeatDot)      :<C-U>exe repeat#run(v:count)<CR>
nnoremap <silent> <Plug>(RepeatUndo)     :<C-U>call repeat#wrap('u',v:count)<CR>
nnoremap <silent> <Plug>(RepeatUndoLine) :<C-U>call repeat#wrap('U',v:count)<CR>
nnoremap <silent> <Plug>(RepeatRedo)     :<C-U>call repeat#wrap("\<Lt>C-R>",v:count)<CR>


if !exists('g:repeat_no_default_key_mappings') || !g:repeat_no_default_key_mappings
    nmap .     <Plug>(RepeatDot)
    nmap u     <Plug>(RepeatUndo)
    nmap U     <Plug>(RepeatUndoLine)
    nmap <C-R> <Plug>(RepeatRedo)
endif

" vim:set ft=vim et sw=4 sts=4:
