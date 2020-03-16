set nocompatible

packadd minpac
call minpac#init()
call minpac#add('k-takata/minpac', {'type': 'opt'})

" viewing
" show and navigate marks
call minpac#add('kshenoy/vim-signature')
" apply colors to different parentheses levels
call minpac#add('junegunn/rainbow_parentheses.vim')
" highlight yanked text
call minpac#add('machakann/vim-highlightedyank')
" view tag information for current file
call minpac#add('majutsushi/tagbar')
" gruvbox theme
call minpac#add('morhetz/gruvbox')
" improved quickfix/loclist  behavior
call minpac#add('romainl/vim-qf')
" use quickfix for include-search and definition-search with tags
call minpac#add('romainl/vim-qlist')
" window pane resize mode
call minpac#add('simeji/winresizer')
" enhanced merge conflicts
call minpac#add('whiteinge/diffconflicts')
" diff entire folders
call minpac#add('will133/vim-dirdiff')
" view line indents
call minpac#add('Yggdroot/indentLine')

" version control
" view git information in gutter
call minpac#add('airblade/vim-gitgutter')
" view git commit history
call minpac#add('junegunn/gv.vim')
" run git commands, view status
call minpac#add('tpope/vim-fugitive')

" editing
" enhanced splitting and joining lines
call minpac#add('AndrewRadev/splitjoin.vim')
" snippet tool
call minpac#add('joereynolds/vim-minisnip')
" align blocks of text
call minpac#add('junegunn/vim-easy-align')
" Add/change/delete surrounding char pairs
call minpac#add('machakann/vim-sandwich')
" Reorder delimited items
call minpac#add('machakann/vim-swap')
" swap text using motions
call minpac#add('tommcdo/vim-exchange')
" comment out lines via motion
call minpac#add('tpope/vim-commentary')
" repeat support for various plugins
call minpac#add('tpope/vim-repeat')

" searching
" hooks for fzf
call minpac#add('junegunn/fzf.vim')
" extra motion for two characters
call minpac#add('justinmk/vim-sneak')
" adds extra info when searching
call minpac#add('osyo-manga/vim-anzu')
" highlighting and enhancements for substitute command
call minpac#add('osyo-manga/vim-over')

" other
" view/edit hex data
call minpac#add('fidian/hexmode')
" opens term or file manager of current file
call minpac#add('justinmk/vim-gtfo')
" directory browser
call minpac#add('justinmk/vim-dirvish')
" open dev docs site for current word
call minpac#add('romainl/vim-devdocs')
" call commands async
call minpac#add('skywind3000/asyncrun.vim')
" unix commands
call minpac#add('tpope/vim-eunuch')
" session support
call minpac#add('tpope/vim-obsession')
" basic settings everyone can agree on
call minpac#add('tpope/vim-sensible')
" vimscript debugger
call minpac#add('tpope/vim-scriptease')
" enhanced tmux support/commands
call minpac#add('tpope/vim-tbone')
" extra keymaps
call minpac#add('tpope/vim-unimpaired')
" enhanced netrw
call minpac#add('tpope/vim-vinegar')
" vim manpager
call minpac#add('vim-utils/vim-man')
" lsp plugins
call minpac#add('prabirshrestha/async.vim')
call minpac#add('prabirshrestha/vim-lsp')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" map leader to space
nnoremap <Space> <nop>
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

" allow reading of per-project .vimrc files
set exrc

" load termdebug plugin
packadd termdebug

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ignore compiled files
set wildignore=*.o,*~,*.pyc,*.d

" height of the command bar
set cmdheight=2

" a buffer becomes hidden when it is abandoned
set hid

" configure backspace so it acts as it should act
set whichwrap+=<,>,h,l

" ignore case when searching
set ignorecase

" when searching try to be smart about cases
set smartcase

" highlight search results
set hlsearch

" don't redraw while executing macros (good performance config)
set lazyredraw

" faster drawing
set ttyfast

" for regular expressions turn magic on
set magic

" show matching brackets when text indicator is over them
set showmatch

" how many tenths of a second to blink when matching brackets
set mat=2

" no annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" add a bit extra margin to the left
set foldcolumn=1

" show absolute line numbers
set number

" disable scratch window preview in omni
set completeopt-=preview

" mouse setup
set mouse=a
set ttymouse=xterm2

" cursor line/column highlighting
set cursorline
" TODO: This is still real slow (hold down h/l and let go to exhibit)
" set cursorcolumn

" show 10 lines below/above cursor at all times
set scrolloff=10

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

" themes
set background=dark
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

" use Unix as the standard file type
set ffs=unix,dos,mac

" make Scons files show up as python
autocmd BufNew,BufRead SConstruct,SConscript set filetype=python

" make clang config files show up as yaml
autocmd BufNew,BufRead .clang-format,.clang-tidy set filetype=yaml

" enable special doxygen highlighting
let g:load_doxygen_syntax=1

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

" tabline config and helper functions
function! MyTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let string = fnamemodify(bufname(buflist[winnr - 1]), ':t')
    return empty(string) ? '[unnamed]' : string
endfunction

function! MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        " select the highlighting
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
        " display tabnumber
        let s .= ' '. (i+1)
        " the label is made by MyTabLabel()
        let s .= ':%{MyTabLabel(' . (i + 1) . ')} '
    endfor
    return s
endfunction

set tabline=%!MyTabLine()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set undo/backup/swap files to directory in home
set undofile
set undodir=~/.vim/.undo//
set backup
set backupdir=~/.vim/.backup//
set directory=~/.vim/.swp//

" reload vimrc manually
nnoremap <leader>vr :source $MYVIMRC<CR>

" automatially reload file if shell command is run inside vim
set autoread

" reload current buffer only if there are no edits
nnoremap <leader>e :edit<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" use spaces instead of tabs
set expandtab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" backspace over automatically inserted indentation
set bs=2

" auto indent
set ai
" smart indent
set si
" wrap lines
set wrap

" set external format tools based on filetype
autocmd FileType python setlocal formatprg=autopep8\ -
autocmd FileType c,cpp setlocal formatprg=clang-format\ --assume-filename=%

" run formatprg, retab, and trim whitespace on entire buffer
function! AutoformatCurrentFile()
    let l:save = winsaveview()
    keepjumps normal gggqG
    retab
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction

nnoremap <leader>i :call AutoformatCurrentFile()<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" tmux-like tab creation
map <leader>c :tabnew<cr>

" quickfix shortcuts
map <silent><c-n> :cn<cr>
map <silent><c-p> :cp<cr>

" quick-map tabs
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

" remap ` jumping to ', since I never use the former
nnoremap ' `

" moving between panes
noremap <c-h> <c-w>h
noremap <c-j> <c-w>j
noremap <c-k> <c-w>k
noremap <c-l> <c-w>l

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" use CLIPBOARD register
set clipboard=unnamedplus

" De-dupe and sort visual selection
vnoremap <leader>ds :'<,'>sort u<cr>

" pipe contents of paste buffer to clipboard via xsel
nnoremap <leader>y :call system("xsel -i --clipboard", getreg("\""))<cr>

" add contents of clipboard to x register (via xsel) and paste
function! Xsel_paste()
    let @x=system('xsel -o --clipboard')
    normal! "xp
endfunction

function! Xsel_paste_before()
    let @x=system('xsel -o --clipboard')
    normal! "xP
endfunction

nnoremap <leader>pp :call Xsel_paste()<cr>
nnoremap <leader>pP :call Xsel_paste_before()<cr>

" replace current inner word with yank reg 0
nnoremap <leader>pw ciw<c-r>0<esc>

" highlight and replace current word cursor is on
nnoremap <leader>r :%s/<C-r><C-w>//gc<Left><Left><Left>

" set <c-d> to forward-delete in insert mode
inoremap <c-d> <del>

" go up/down command history
cnoremap <c-j> <down>
cnoremap <c-k> <up>

" map Y to yank until end of line
nmap Y y$

" yank/delete entire C-style functions
map <leader>Y Vf{%d
map <leader>D Vf{%y

" open index in personal wiki
nmap <leader>ww :tabe ~/wiki/index.md<cr>
" use pandoc to create pdf of markdown file and dump in /tmp
nmap <leader>wc :AsyncRun pandoc --output $(VIM_FILENOEXT).pdf %:p<cr>

" all cscope results go to quickfix and not wonky number-driven list
set cscopequickfix=s-,g-,d-,c-,t-,e-,f-,i-,a-

" TODO: Figure out if I eventually want to use these or not
" cscope queries
" Search for all callers of the function name under the cursor
" nmap ,c :cs find c <C-R>=expand('<cword>')<CR><CR>
" Search all the functions called by funtion name under the cursor
" nmap ,g :cs find d <C-R>=expand('<cword>')<CR><CR>
" Search for global definition of the word under the cursor
" nmap ,d :cs find g <C-R>=expand('<cword>')<CR><CR>
" Search for all files matching filename under the cursor
" nmap ,f :cs find f <C-R>=expand('<cfile>')<CR><CR>
" Search for all files including filename under the cursor
" nmap ,i :cs find i <C-R>=expand('<cfile>')<CR><CR>
" Search for all symbol occurances of word under the cursor
" nmap ,s :cs find s <C-R>=expand('<cword>')<CR><CR>

" set ripgrep as grep program
set grepprg=rg\ --vimgrep\ --smart-case
set grepformat=%f:%l:%c:%m

" quick-execute macro q
nnoremap Q @q

" use patience diff algorithm
set diffopt=internal,algorithm:patience,indent-heuristic

" call rubber compiling current tex file
nnoremap <leader>x :w<cr>:silent !rubber --pdf --warn all %<cr>:redraw!<cr>

" view PDF equivalent of current file's root name
nnoremap <leader>X :!zathura %:r.pdf &<cr><cr>

" quick maps for diff get/put
nmap <leader>dt :windo diffthis<cr>
" force update of diff
nmap <leader>du :diffupdate!<cr>
" turn off all diff views
nmap <leader>do :diffoff!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Debugging
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap ,b :Break<cr>
nmap ,d :Clear<cr>
nmap ,s :Step<cr>
nmap ,S :Stop<cr>
nmap ,n :Over<cr>
nmap ,f :Finish<cr>
nmap ,c :Continue<cr>
nmap ,e :Evaluate<cr>
nmap ,g :Gdb<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-signature
" highlight colors marks based on gitgutter status
let g:SignatureMarkTextHLDynamic = 1

" vim-dirvish
" dirvish sidetab
command! VleftDirvish leftabove vsplit | vertical resize 50 | silent Dirvish
nnoremap - :VleftDirvish<CR>
nnoremap gx :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())<cr>

" indentLine
" turn off indentLine by default
let g:indentLine_enabled = 0

" toggle indentLine plugin (aka show indent markings)
nmap <leader>I :IndentLinesToggle<cr>

" ale
" disable ALE on start
let g:ale_enabled = 0
let g:ale_lint_on_text_changed = 'never'

" toggle on/off ALE Linter
nmap <leader>L <Plug>(ale_toggle)

" jump to ale errors
nmap [w <Plug>(ale_previous_wrap)
nmap ]w <Plug>(ale_next_wrap)
nmap ]W <Plug>(ale_last)
nmap [W <Plug>(ale_first)

" asyncrun
" stop asyncrun, redraw, and disable highlighting
nmap <leader><esc> :AsyncStop<cr>:redraw!<cr>:noh<cr>
nmap <leader>/ :AsyncRun -program=grep ""<left>
nmap <leader>f :AsyncRun -program=grep "<c-r><c-w>"<cr>
" search for all todo/fixme and put into quickfix list
nmap <leader>T :AsyncRun -program=grep '(TODO\|FIXME)'<cr>
" async make with parallel jobs
nmap <leader>mm :AsyncRun make -j<cr>
" async make clean
nmap <leader>mc :AsyncRun make clean<cr>
" async make clang-tidy
nmap <leader>mt :AsyncRun make clang-tidy<cr>
" async make with parallel jobs and flash when done
nmap <leader>mf :AsyncRun make -j && make flash<cr>
" generate ctags and gtags
nmap <leader>j :AsyncRun ctags<cr>
" TODO: Figure out how to also plug in loading the cscope database
nmap ,tg :AsyncRun gtags<cr>
" make asyncrun work with vim-fugitive
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" vim-fugitive
" toggle git blame
nmap <leader>gb :Gblame<cr>
" git status toggle function
function! ToggleGStatus()
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Gstatus
    endif
endfunction
nmap <leader>gs :call ToggleGStatus()<cr>
" git push
nmap <leader>gp :Gpush<cr>
" git commit
nmap <leader>gc :Gcommit<space>-v<cr>
" write (essentially a write and git add)
nmap <leader>gw :Gwrite<cr>
" git diff of current file against HEAD
nmap <leader>gd :Gvdiff<cr>

" gv.vim
" load git history of file into location list
nmap <leader>gl :GV?<cr>
" open git browser with all commits touching current file in new tab
nmap <leader>gh :GV!<cr>
" open git browser
nmap <leader>gv :GV<cr>

" tagbar
" toggle pane of tags
nmap <leader>t :TagbarToggle<cr>

" hexmode
" toggle Hexmode
nmap <leader>H :Hexmode<cr>

" vim-qf
" disable wrapping in quickfix
let g:qf_nowrap = 0
" toggle location list
nmap <leader>Q <Plug>QfLtoggle
" toggle quickfix list
nmap <leader>q <Plug>QfCtoggle

" vim-easy-align
" start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" rainbow_parentheses.vim
" toggle rainbow parentheses
nmap <leader>P :RainbowParentheses!!<cr>

" replace in quickfix list what word the cursor is currently on
nmap <leader>R :cdo %s/<C-r><C-w>//gc<Left><Left><Left>

" vim-anzu
" use anzu to echo search information
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)

" fzf.vim
" open FZF pane
nmap <leader>o :FZF<cr>
" use fd for FZF (which respects .gitignore)
let $FZF_DEFAULT_COMMAND = 'fd --type f --color=never'

" minpac
" update plugins
nmap <leader>pu :call minpac#update()<cr>
" clean plugins
nmap <leader>pc :call minpac#clean()<cr>

" vim-minisnip
" remap minisnip default trigger
let g:minisnip_trigger = '<c-s>'

" vim-sandwich
" Use vim-surround mappings (minpac doesn't support runtime option)
source ~/.vim/pack/minpac/start/vim-sandwich/macros/sandwich/keymap/surround.vim

" winresizer
" Enter resizer mode
let g:winresizer_start_key = '<leader>W'

" vim-sneak
" enable label mode for easymotion-like behavior
let g:sneak#label = 1
" use vimrc case settings (e.g. smartcase)
let g:sneak#use_ic_scs = 1
" use clever-s (e.g. s/S go next/prev)
let g:sneak#s_next = 1

" vim-over
" start enhanced substitution
nmap <leader>S :OverCommandLine %s/<cr>

" vim-devdocs
" look up current word cursor is on in devdocs.io
nmap <leader>k :DD <c-r><c-w><cr>

" lsp setup
if executable('clangd')
    augroup lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
                    \ 'whitelist': ['c', 'cpp'],
                    \ })
        autocmd FileType c setlocal omnifunc=lsp#complete
        autocmd FileType cpp setlocal omnifunc=lsp#complete
    augroup end
endif

let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_auto_enable = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Last
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable shell and write commands (because we set exrc earlier)
set secure
