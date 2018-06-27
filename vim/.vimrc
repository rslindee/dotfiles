set nocompatible

" auto-clone and install minpac if not installed
if empty(glob('~/.vim/pack/minpac/opt/minpac/plugin/minpac.vim'))
    silent !git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac
    autocmd VimEnter * call minpac#update() | source $MYVIMRC
endif


packadd minpac
call minpac#init()
call minpac#add('k-takata/minpac', {'type': 'opt'})

" Viewing
" Use git diffing algos for improved diffs
call minpac#add('chrisbra/vim-diff-enhanced')
" Show and navigate marks
call minpac#add('kshenoy/vim-signature')
" Highlight errors
call minpac#add('rslindee/vim-hier')
" Apply colors to different parentheses levels
call minpac#add('junegunn/rainbow_parentheses.vim')
" View tag information for current file
call minpac#add('majutsushi/tagbar')
" Diff entire folders
call minpac#add('will133/vim-dirdiff')
" Improved quickfix/loclist  behavior
call minpac#add('romainl/vim-qf')
" Use quickfix for include-search and definition-search
call minpac#add('romainl/vim-qlist')
" Window pane resize mode
call minpac#add('simeji/winresizer')
" View line indents
call minpac#add('Yggdroot/indentLine')

" Version Control
" View git information in gutter
call minpac#add('airblade/vim-gitgutter')
" View, edit, merge branches
call minpac#add('idanarye/vim-merginal')
" View git commit history
call minpac#add('junegunn/gv.vim')
" Run git commands, view status
call minpac#add('tpope/vim-fugitive')

" Themes
call minpac#add('morhetz/gruvbox')

" Editing
" Enhanced splitting and joining lines
call minpac#add('AndrewRadev/splitjoin.vim')
" Uses external formatting tools
call minpac#add('Chiel92/vim-autoformat')
" Snippet tool
call minpac#add('joereynolds/vim-minisnip')
" Align blocks of text
call minpac#add('junegunn/vim-easy-align')
" TODO: Re-add and ensure performance is ok
"Plug 'lifepillar/vim-mucomplete'
call minpac#add('machakann/vim-sandwich')
" TODO: Re-add and ensure performance is ok
"Plug 'Rip-Rip/clang_complete'
" Swap text using motions
call minpac#add('tommcdo/vim-exchange')
call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-repeat')

" Searching
call minpac#add('junegunn/fzf.vim')
" Extra motion for two characters
call minpac#add('justinmk/vim-sneak')
call minpac#add('osyo-manga/vim-anzu')
call minpac#add('osyo-manga/vim-over')

" Other
" View/edit hex data
call minpac#add('fidian/hexmode')
call minpac#add('justinmk/vim-gtfo')
call minpac#add('justinmk/vim-dirvish')
call minpac#add('romainl/vim-devdocs')
call minpac#add('skywind3000/asyncrun.vim')
call minpac#add('tpope/vim-eunuch')
call minpac#add('tpope/vim-obsession')
call minpac#add('tpope/vim-sensible')
call minpac#add('tpope/vim-scriptease')
call minpac#add('tpope/vim-tbone')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('tpope/vim-vinegar')
call minpac#add('vim-scripts/DoxygenToolkit.vim')
call minpac#add('vim-utils/vim-man')
call minpac#add('w0rp/ale')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map leader to space
nnoremap <Space> <nop>
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ignore compiled files
set wildignore=*.o,*~,*.pyc,*.d

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" Faster drawing
set ttyfast

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Add a bit extra margin to the left
set foldcolumn=1

" Show absolute line numbers
set number

" Disable scratch window preview in omni
set completeopt-=preview

" Mouse setup
set mouse=a
set ttymouse=xterm2

" Line highlighting
set cursorline
set cursorcolumn

" Show 10 lines below/above cursor at all times
set scrolloff=10

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set Vim-specific sequences for RGB colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

" Themes
set background=dark
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Make Scons files show up as python
autocmd BufNew,BufRead SConstruct,SConscript set filetype=python

" Make clang config files show up as yaml
autocmd BufNew,BufRead .clang-format,.clang-tidy set filetype=yaml

" Enable special doxygen highlighting
let g:load_doxygen_syntax=1

" Statusline config and helper functions
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

" Clear statusline
set statusline=
" Filename
set statusline+=\ %f
" Modified or modifiable flag
set statusline+=%m\ "
" Current vim working directory
set statusline+=┃\ %{StatuslineWorkingDir()}\ "
" Git repo information
set statusline+=%{StatuslineGit()}
" Start right justify and truncation point
set statusline+=%=%<
" Line and col
set statusline+=%l,%c\ "
" Percent location in file
set statusline+=┃\ %P\ "
" File modification date/time
set statusline+=┃\ %{StatuslineModificationTime()}\ "

" Tabline config and helper functions
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
" Set undo/backup/swap files to directory in home
set undofile
set undodir=~/.vim/.undo//
set backup
set backupdir=~/.vim/.backup//
set directory=~/.vim/.swp//

" Reload vimrc manually
nnoremap <leader>vr :source $MYVIMRC<CR>

" Automatially reload file if shell command is run inside vim
set autoread

" Reload current buffer only if there are no edits
nnoremap <leader>e :edit<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Backspace over automatically inserted indentation
set bs=2

" Auto indent
set ai
" Smart indent
set si
" Wrap lines
set wrap

" auto-trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" tmux-like tab creation
map <leader>c :tabnew<cr>

" Map splits to be like tmux
map <leader>" :sp<cr>
map <leader>% :vsp<cr>

" Cope shortcuts
map <silent><c-n> :cn<cr>
map <silent><c-p> :cp<cr>

" Quick-map tabs
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use system clipboard
set clipboard=unnamed

" pipe contents of paste buffer to xclip
nnoremap <leader>yy :call system('xclip', @0)<CR>

" add contents of xclip to x register and paste
function! Xclip_paste()
    let @x=system('xclip -o -sel clip')
    normal! "xp
endfunction

function! Xclip_paste_before()
    let @x=system('xclip -o -sel clip')
    normal! "xP
endfunction

nnoremap <leader>pp :call Xclip_paste()<CR>
nnoremap <leader>pP :call Xclip_paste_before()<CR>

" Highlight and replace current word cursor is on
nnoremap <leader>r :%s/<C-r><C-w>//gc<Left><Left><Left>

" Set <c-d> to forward-delete in insert mode
inoremap <c-d> <del>

" Go up/down command history
cnoremap <c-j> <down>
cnoremap <c-k> <up>

" Map Y to yank until end of line
nmap Y y$

" Yank/delete entire C-style functions
map <leader>yf Vf{%d
map <leader>df Vf{%y

" Open index in personal wiki
nmap <leader>ww :tabe ~/wiki/index.md<cr>
" Use pandoc to create pdf of markdown file and dump in /tmp
nmap <leader>wc :AsyncRun pandoc --output $(VIM_FILENOEXT).pdf %:p<cr>

" All cscope results go to quickfix and not wonky number-driven list
set cscopequickfix=s-,g-,d-,c-,t-,e-,f-,i-,a-

" cscope queries
" Search for all callers of the function name under the cursor
nmap ,c :cs find c <C-R>=expand('<cword>')<CR><CR>
" Search all the functions called by funtion name under the cursor
nmap ,g :cs find d <C-R>=expand('<cword>')<CR><CR>
" Search for global definition of the word under the cursor
nmap ,d :cs find g <C-R>=expand('<cword>')<CR><CR>
" Search for all files matching filename under the cursor
nmap ,f :cs find f <C-R>=expand('<cfile>')<CR><CR>
" Search for all files including filename under the cursor
nmap ,i :cs find i <C-R>=expand('<cfile>')<CR><CR>
" Search for all symbol occurances of word under the cursor
nmap ,s :cs find s <C-R>=expand('<cword>')<CR><CR>

" Set ripgrep as grep program
set grepprg=rg\ --vimgrep
set grepformat=%f:%l:%c:%m

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: Disabled this for now, as it was causing errors on startup when marks
" were left. See https://github.com/kshenoy/vim-signature/issues/141
" vim-signature highlight marks based on gitgutter status
"let g:SignatureMarkTextHLDynamic = 1

" Dirvish sidetab
command! VleftDirvish leftabove vsplit | vertical resize 50 | silent Dirvish
nnoremap - :VleftDirvish<CR>
nnoremap gx :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())<cr>

" Disable vim-hier by default
let g:hier_enabled = 0

" Toggle vim-hier for quickfix warning/error highlighting
nmap <leader>Q :HierToggle<cr>

" Turn off indentLine by default
let g:indentLine_enabled = 0

" Toggle indentLine plugin (aka show indent markings)
nmap <leader>I :IndentLinesToggle<cr>

" Disable ALE on start
let g:ale_enabled = 0
let g:ale_lint_on_text_changed = 'never'

" Toggle on/off ALE Linter
nmap <leader>L <Plug>(ale_toggle)

" Jump to ale errors
nmap [w <Plug>(ale_previous_wrap)
nmap ]w <Plug>(ale_next_wrap)
nmap ]W <Plug>(ale_last)
nmap [W <Plug>(ale_first)

nmap <leader>a :AsyncRun -program=grep<space>
nmap <leader>s :AsyncRun -program=grep <c-r><c-w><cr>

" Toggle fugitive Git blame
nmap <leader>gb :Gblame<cr>

" fugitive git status toggle function
function! ToggleGStatus()
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Gstatus
    endif
endfunction
nmap <leader>gs :call ToggleGStatus()<cr>

" Load git history of file into location list
nmap <leader>gl :GV?<cr>

" Load fugitive git diff of current file against HEAD
nmap <leader>gd :Gvdiff<cr>

" Open git browser with all commits touching current file in new tab
nmap <leader>gh :GV!<cr>

" Open git browser
nmap <leader>gv :GV<cr>

" Fugitive git push
nmap <leader>gp :Gpush<cr>

" Fugitive git commit
nmap <leader>gc :Gcommit<space>-v<cr>

" Fugitive write (essentially a write and git add)
nmap <leader>gw :Gwrite<cr>

" Toggle Tagbar
nmap <leader>t :TagbarToggle<cr>

" Toggle Hexmode
nmap <leader>H :Hexmode<cr>

" Disable wrapping in quickfix
let g:qf_nowrap = 0

" Toggle location list vim-qf
nmap <leader>l <Plug>QfLtoggle

" Toggle quickfix list vim-qf
nmap <leader>q <Plug>QfCtoggle

" Search for all todo/fixme and put into quickfix list
nmap <leader>T :AsyncRun -program=grep '(TODO\|FIXME)'<cr>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Toggle rainbow parentheses
nmap <leader>R :RainbowParentheses!!<cr>

" Use anzu to echo search information
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)

nmap <leader>o :FZF<cr>
" Use for FZF (which respects .gitignore)
let $FZF_DEFAULT_COMMAND = 'fd --type f --color=never'

" Async make with 4 jobs
nmap <leader>mm :AsyncRun make -j4<cr>

" Async make clean
nmap <leader>mc :AsyncRun make clean<cr>

" Async make clang-tidy
nmap <leader>mt :AsyncRun make clang-tidy<cr>

" LaTeX (rubber) macro for compiling
nnoremap <leader>x :w<CR>:silent !rubber --pdf --warn all %<cr>:redraw!<cr>

" View PDF macro; '%:r' is current file's root (base) name.
nnoremap <leader>X :!zathura %:r.pdf &<cr><cr>

" Run vim-autoformat on entire file (falls back to vim's default
" tabbing/spacing if filetype is unsupported by any formatprogram)
nmap <leader>i :Autoformat<cr>

let g:formatdef_autopep8 = "'autopep8 --max-line-length 100 - --range '.a:firstline.' '.a:lastline"
let g:formatters_python = ['autopep8']

" minpac binds
nmap <leader>pu :call minpac#update()<cr>
nmap <leader>pc :call minpac#clean()<cr>

" Remap minisnip trigger
let g:minisnip_trigger = '<c-s>'

" Use vim-surround mappings with sandwich
" TODO: This is a little non-ideal, we should be able to use runtime,
" but this appears a little tricky with minpac
source ~/.vim/pack/minpac/start/vim-sandwich/macros/sandwich/keymap/surround.vim

" TODO: Re-add and ensure performance is ok
" mucomplete-required settings
"set completeopt+=menuone
"set completeopt+=noinsert
"inoremap <expr> <c-e> mucomplete#popup_exit("\<c-e>")
"inoremap <expr> <c-y> mucomplete#popup_exit("\<c-y>")
"inoremap <expr>  <cr> mucomplete#popup_exit("\<cr>")
"set shortmess+=c   " Shut off completion messages

" Enter resizer mode
let g:winresizer_start_key = '<leader>W'

" Generate ctags and gtags
nmap ,tc :AsyncRun ctags<cr>
" TODO Figure out how to also plug in loading the cscope datatbase
nmap ,tg :AsyncRun gtags<cr>

" Make ayncrun to work with vim-fugitive
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" Enable vim-sneak label mode for easymotion-like behavior
let g:sneak#label = 1

" Use vimrc case settings (e.g. smartcase) for vim-sneak
let g:sneak#use_ic_scs = 1

" Use xdg-open to open browser for devdocs.io
let g:devdocs_open_command = "xdg-open"
