" Vim filetype plugin file
" Language:	Mail

let b:did_ftplugin = 1

" Don't use modelines in e-mail messages, avoid trojan horses and nasty
" "jokes" (e.g., setting 'textwidth' to 5).
setlocal nomodeline
