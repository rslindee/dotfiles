
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" De-dupe and sort visual selection
vnoremap <leader>ds :'<,'>sort u<cr>

" yank filename to clipboard
nnoremap <leader>yf :let @+=expand("%:t")<CR>
" yank file path relative to current vim dir to clipboard
nnoremap <leader>yr :let @+=expand("%:p:.")<CR>
" yank absolutely file path to clipboard
nnoremap <leader>ya :let @+=expand("%:p")<CR>

" ripgrep, but include all hidden/ignored files
command! -nargs=+ GrepAll execute 'silent grep! <args> -uu' | execute ':redraw!'

" open corresponding .h file of current .c file and vice-versa
map <leader>H :e %:p:s,.h$,.X1X,:s,.c$,.h,:s,.X1X$,.c,<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-signature
" highlight colors marks based on gitgutter status
let g:SignatureMarkTextHLDynamic = 1

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
" generate ctags and gtags
" TODO: replace with something more auto
" nmap <leader>j :AsyncRun ctags -R .<cr>
" run whatever defined makeprg
nmap <leader>ml :AsyncRun -program=make %<cr>
" make asyncrun work with vim-fugitive
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" vim-fugitive
" toggle git blame
nmap <leader>gb :Git blame<cr>
" git status toggle function
function! ToggleGStatus()
  if buflisted(bufname('.git/index'))
    bd .git/index
  else
    Git
  endif
endfunction
nmap <leader>gs :call ToggleGStatus()<cr>
" vim-qf
" disable wrapping in quickfix
let g:qf_nowrap = 0
" toggle location list
nmap <leader>Q <Plug>QfLtoggle
" toggle quickfix list
nmap <leader>q <Plug>QfCtoggle

" use fzf for path completion
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('fd')

" use fd for FZF (which respects .gitignore)
let $FZF_DEFAULT_COMMAND = 'fd --type f --color=never'
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8, 'xoffset': 1 } }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Last
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" load machine-specific configs/overrides
try
  source ~/.vim/vimrc-local
catch
endtry
