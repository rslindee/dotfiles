" statusline config and helper functions
function! StatuslineGit()
  let l:branchname = FugitiveHead(7)
  return strlen(l:branchname) > 0?'┃ ├'.l:branchname:''
endfunction

function! StatuslineModificationTime()
  let ftime = getftime(expand('%'))
  return ftime != -1 ? strftime('%m/%d/%y %H:%M', ftime) : ''
endfunction

function! StatuslineWorkingDir()
  let workingdir = fnamemodify(getcwd(), ':t')
  return workingdir
endfunction

" clear statusline
set statusline=
" filename
set statusline+=\ %f
" modified or modifiable flag
set statusline+=%m\ "
" current vim working directory
set statusline+=┃\ %{StatuslineWorkingDir()}\ "
" git repo information
set statusline+=%{StatuslineGit()}
" start right justify and truncation point
set statusline+=%=%<
" line and col
set statusline+=%l,%c\ "
" percent location in file
set statusline+=┃\ %P\ "
" file modification date/time
set statusline+=┃\ %{StatuslineModificationTime()}\ "

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ripgrep, but include all hidden/ignored files
command! -nargs=+ GrepAll execute 'silent grep! <args> -uu' | execute ':redraw!'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" asyncrun
" stop asyncrun, redraw, and disable highlighting
nmap <leader><esc> :AsyncStop<cr>:redraw!<cr>:noh<cr>
nmap <leader>/ :silent! grep ""<left>
nmap <leader>? :GrepAll ""<left>
nmap <leader>f :silent! grep "<c-r><c-w>"<cr>
nmap <leader>F :GrepAll "<c-r><c-w>"<cr>
" search for all todo/fixme and put into quickfix list
" nmap <leader>T :AsyncRun -program=grep '(TODO\|FIXME)'<cr>
" Run last make command
nmap <leader>mr :make<up><cr>
" Run make
nmap <leader>mm :silent make!<cr>:redraw!<cr>
" async make clean
nmap <leader>mc :Make clean<cr>
" run whatever defined makeprg
nmap <leader>ml :AsyncRun -program=make %<cr>
" make asyncrun work with vim-fugitive
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" vim-qf
" disable wrapping in quickfix
let g:qf_nowrap = 0
" toggle location list
nmap <leader>Q <Plug>QfLtoggle
" toggle quickfix list
nmap <leader>q <Plug>QfCtoggle

