set nocompatible

" auto-clone and install vim-plug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" vim-plug plugin manager:
call plug#begin()

Plug 'airblade/vim-gitgutter'
Plug 'craigemery/vim-autotag'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'fidian/hexmode'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/gv.vim'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-grepper'
Plug 'nanotech/jellybeans.vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-unimpaired'
Plug 'Valloric/ListToggle'

call plug#end()

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
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

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

" Line/Column highlighting
set cursorline

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set bs=2
set t_Co=256

" Themes
set background=dark
colo jellybeans

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Make arduino extensions show up as cpp highlighting
autocmd BufNewFile,BufReadPost *.ino,*.pde set filetype=cpp
" Make Scons files show up as python
autocmd BufNew,BufRead SConstruct,SConscript set filetype=python

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off
set nobackup
set nowb
set noswapfile

" For whatever reason I still see undo files getting created...
set noundofile

" Reload vimrc manually
nnoremap <leader>vr :source $MYVIMRC<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" auto-trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Temporarily(?) disable arrow keys to form better habit of hjkl usage
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

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
" Remove the Windows ^M - when the encodings gets messed up
noremap <leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Toggle paste mode
map <leader>P :setlocal paste!<cr>

" Use system clipboard
set clipboard=unnamed

" Call make
nnoremap <leader><cr> :make<cr>

" Toggle spellcheck
map <leader>S :setlocal spell!<cr>

" Highlight and replace current word cursor is on
nnoremap <leader>r :%s/<C-r><C-w>//gc<Left><Left><Left>

" Call ctags
nmap <leader>C :silent !ctags<cr>:redraw!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CtrlP Config
" Ignore the buffer searching feature of CtrlP
let g:ctrlp_types = ['fil', 'mru', 'buf']
let g:ctrlp_extensions = ['tag', 'quickfix']
" Remap ctrlp invocation away from <c-p>
let g:ctrlp_map = '<c-a>'
" Make Ctrlp to stay in the first working directory it was invoked within, unless
" :cd command is issued to an outside dir
let g:ctrlp_working_path_mode = 'a'
" Use ag to index files
if executable('ag')
    " Use ag in CtrlP for listing files. fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
endif

" Lightline Config
" Lightline arrangement
let g:lightline = {
            \ 'colorscheme': 'jellybeans',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ], [ 'ctrlp', 'filename' ], [ 'workingdir', 'fugitive' ] ],
            \   'right': [ [ 'lineinfo' ], ['percent'], [ 'modificationtime' ] ]
            \ },
            \ 'inactive': {
            \   'left': [ [ 'filename' ] ],
            \   'right': [ [ 'lineinfo' ], ['percent'], [ 'modificationtime' ] ]
            \ },
            \ 'component_function': {
            \   'fugitive': 'LightLineFugitive',
            \   'workingdir': 'LightLineWorkingDir',
            \   'filename': 'LightLineFilename',
            \   'ctrlp': 'LightlineCtrlP',
            \   'mode': 'LightLineMode',
            \   'modificationtime': 'LightLineModificationTime',
            \ },
            \ 'subseparator': { 'left': '│', 'right': '│' }
            \ }
let g:lightline.mode_map = {
            \ 'n' : 'N',
            \ 'i' : 'I',
            \ 'R' : 'R',
            \ 'v' : 'V',
            \ 'V' : 'V',
            \ "\<C-v>": 'V',
            \ 'c' : 'C',
            \ 's' : 'S',
            \ 'S' : 'S',
            \ "\<C-s>": 'S',
            \ 't': 'T',
            \ }

function! LightlineCtrlP()
    if expand('%:t') =~ 'ControlP'
        if exists('g:lightline.ctrlp_status')
            return g:lightline.ctrlp_status
        else
            return ''
        endif
    else
        return ''
    endif
endfunction

function! LightLineModificationTime()
    let ftime = getftime(expand('%'))
    return ftime != -1 ? strftime('%m.%d.%y %H:%M', ftime) : ''
endfunction

function! LightLineModified()
    return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
    return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! LightLineWorkingDir()
    let workingdir = fnamemodify(getcwd(), ':t')
    return workingdir
endfunction

function! LightLineFilename()
    let fname = expand('%:t')
    return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
                \ expand('%') =~ '__Tagbar__' ? g:lightline.fname :
                \ fname =~ 'NERD_tree' ? '' :
                \ ('' != LightLineReadonly() ? LightLineReadonly() . ' │ ' : '') .
                \ ('' != fname ? fname : '[No Name]') .
                \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
    try
        if expand('%:t') !~? '__Tagbar__\|NERD_tree' && exists('*fugitive#head')
            let mark = '├'  " edit here for cool branch mark
            let branch = fugitive#head()
            return branch !=# '' ? mark.branch : ''
        endif
    catch
    endtry
    return ''
endfunction

function! LightLineMode()
    let fname = expand('%:t')
    return fname == '__Tagbar__' ? 'Tagbar' :
                \ fname == 'ControlP' ? 'CtrlP' :
                \ fname =~ 'NERD_tree' ? 'NERD' :
                \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

let g:ctrlp_status_func = {
            \ 'main': 'CtrlPStatusMain',
            \ 'prog': 'CtrlPStatusProgress',
            \ }

function! CtrlPStatusMain(focus, byfname, regex, prev, item, next, marked)
    let g:lightline.ctrlp_regex = a:regex
    let g:lightline.ctrlp_prev = a:prev
    let g:lightline.ctrlp_item = a:item
    let g:lightline.ctrlp_next = a:next
    silent! unlet g:lightline.ctrlp_status
    return lightline#statusline(0)
endfunction

function! CtrlPStatusProgress(status)
    let g:lightline.ctrlp_status = a:status
    return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
    return lightline#statusline(0)
endfunction

" Set max tag file size to ~100mb for autotag
let g:autotagmaxTagsFileSize = 100000000

" gitgutter behaves slowly when checking changes on context switch
let g:gitgutter_eager = 0
" Clear all default gitgutter mappings (default conflicts with <leader>h, etc)
let g:gitgutter_map_keys = 0

" Make grepper prompt smaller
let g:grepper = {
            \ 'simple_prompt': 1,
            \ }

" Map useful gitgutter commands
nmap ]g <Plug>GitGutterNextHunk
nmap [g <Plug>GitGutterPrevHunk
nmap <leader>u <Plug>GitGutterUndoHunk
nmap <leader>a <Plug>GitGutterStageHunk

" Map vim-grepper search current word with Ag
nmap <leader>f :GrepperAg <c-r><c-w><cr>

" Map vim-grepper to simply start
nmap <leader>h :Grepper<cr>

" Open fugitive Git blame
nmap <leader>b :Gblame<cr>

" fugitive git status toggle function
function! ToggleGStatus()
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Gstatus
    endif
endfunction
nmap <leader>s :call ToggleGStatus()<cr>

" Load fugitive git history of file quickfix list and open in new tab
nmap <leader>gl :Glog<cr><cr>

" Load fugitive git diff of current file
nmap <leader>d :Gvdiff<cr>

" Open fugitive and load all commits touching current file into quickfix
nmap <leader>gh :Glog<space>--<space>%<cr><cr>

" Fugitive git push
nmap <leader>gp :Gpush<cr>

" Fugitive git commit
nmap <leader>gc :Gcommit<space>-v<cr>

" Fugitive write (essentially a write and git add)
nmap <leader>gw :Gwrite<cr>

" Toggle NERDTree
nmap <leader>n :NERDTreeToggle<cr>

" Toggle Tagbar
nmap <leader>t :TagbarToggle<cr>

" Toggle Hexmode
nmap <leader>H :Hexmode<cr>

" Toggle location list
let g:lt_location_list_toggle_map = '<leader>l'

" Toggle quickfix list
let g:lt_quickfix_list_toggle_map = '<leader>q'

" Search for all todo/fixme and put into quickfix list
 map <leader>T :GrepperAg '(TODO\|FIXME)'<cr>
