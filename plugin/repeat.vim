" repeat.vim - Let the repeat command repeat plugin maps
" Maintainer:   Tim Pope
" Version:      1.2
" GetLatestVimScripts: 2136 1 :AutoInstall: repeat.vim

" Installation:
" Use a plugin manager.
"
" For manual installation copy plugin/repeat.vim and autoload/repeat.vim into
" ~/.vim/plugin/repeat.vim and ~/.vim/autoload/repeat.vim respectively.
"
" License:
" Copyright (c) Tim Pope.  Distributed under the same terms as Vim itself.
" See :help license
"
" Developers:
" Basic usage is as follows:
"
"   silent! call repeat#set("\<Plug>MappingToRepeatCommand",3)
"
" The first argument is the mapping that will be invoked when the |.| key is
" pressed.  Typically, it will be the same as the mapping the user invoked.
" This sequence will be stuffed into the input queue literally.  Thus you must
" encode special keys by prefixing them with a backslash inside double quotes.
"
" The second argument is the default count.  This is the number that will be
" prefixed to the mapping if no explicit numeric argument was given.  The
" value of the v:count variable is usually correct and it will be used if the
" second parameter is omitted.  If your mapping doesn't accept a numeric
" argument and you never want to receive one, pass a value of -1.
"
" Make sure to call the repeat#set function _after_ making changes to the
" file.
"
" For mappings that use a register and want the same register used on
" repetition, use:
"
"   silent! call repeat#setreg("\<Plug>MappingToRepeatCommand", v:register)
"
" This function can (and probably needs to be) called before making changes to
" the file (as those typically clear v:register).  Therefore, the call sequence
" in your mapping will look like this:
"
"   nnoremap <silent> <Plug>MyMap
"   \   :<C-U>execute 'silent! call repeat#setreg("\<lt>Plug>MyMap", v:register)'<Bar>
"   \   call <SID>MyFunction(v:register, ...)<Bar>
"   \   silent! call repeat#set("\<lt>Plug>MyMap")<CR>

if exists("g:loaded_repeat") || &cp || v:version < 800
    finish
endif
let g:loaded_repeat = 1

let g:repeat_tick = -1
let g:repeat_reg = ['', '']

nnoremap <silent> <Plug>(RepeatDot)      :<C-U>if !repeat#run(v:count)<Bar>echoerr repeat#errmsg()<Bar>endif<CR>
nmap <silent><expr><script> <Plug>(RepeatUndo)     repeat#wrap('u',v:count)
nmap <silent><expr><script> <Plug>(RepeatUndoLine) repeat#wrap('U',v:count)
nmap <silent><expr><script> <Plug>(RepeatRedo)     repeat#wrap("\022",v:count)

if !hasmapto('<Plug>(RepeatDot)', 'n')
    nmap . <Plug>(RepeatDot)
endif
if !hasmapto('<Plug>(RepeatUndo)', 'n')
    nmap u <Plug>(RepeatUndo)
endif
if maparg('U','n') ==# '' && !hasmapto('<Plug>(RepeatUndoLine)', 'n')
    nmap U <Plug>(RepeatUndoLine)
endif
if !hasmapto('<Plug>(RepeatRedo)', 'n')
    nmap <C-R> <Plug>(RepeatRedo)
endif

augroup repeatPlugin
    autocmd!
    autocmd BufLeave,BufWritePre,BufReadPre * let g:repeat_tick = (g:repeat_tick == b:changedtick || g:repeat_tick == 0) ? 0 : -1
    autocmd BufEnter,BufWritePost * if g:repeat_tick == 0|let g:repeat_tick = b:changedtick|endif
augroup END

" vim:set ft=vim et sw=4 sts=4:
