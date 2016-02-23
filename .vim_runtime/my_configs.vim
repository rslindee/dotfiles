set autochdir
set number

"auto-trim trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

"make arduino extensions show up as cpp
autocmd BufNewFile,BufReadPost *.ino,*.pde set filetype=cpp

"themes

set background=light
colorscheme solarized
let g:solarized_termcolors=256
let g:airline_powerline_fonts = 1
let g:airline_theme='solarized'
