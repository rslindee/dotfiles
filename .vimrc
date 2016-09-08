" Prerequisites:
" Ruby for vim-plug
" the_silver_searcher for ag
" base16 for shell for theme

set nocompatible

" auto-install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" vim-plug plugin manager:
call plug#begin()

Plug 'ajh17/VimCompletesMe'
Plug 'airblade/vim-gitgutter'
Plug 'chriskempson/base16-vim'
Plug 'ctrlpvim/ctrlp.vim'
" TODO: replace with ack.vim, tried to on 7/7/16, but didn't work well with Ag
Plug 'junegunn/gv.vim'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

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
set wildignore=*.o,*~,*.pyc,*.d,*.map

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

" Show relative line numbers
set relativenumber

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

" Themes
let base16colorspace=256  " Access colors present in 256 colorspace
set background=dark
colorscheme base16-eighties
let g:airline_powerline_fonts = 1
let g:airline_mode_map = {
      \ '__' : '-',
      \ 'n'  : 'N',
      \ 'i'  : 'I',
      \ 'R'  : 'R',
      \ 'c'  : 'C',
      \ 'v'  : 'V',
      \ 'V'  : 'V',
      \ '' : 'V',
      \ 's'  : 'S',
      \ 'S'  : 'S',
      \ '' : 'S',
      \ }
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline_theme = 'base16_eighties'

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

" tmux-like way to move between windows
map <leader>j <C-W>j
map <leader>k <C-W>k
map <leader>h <C-W>h
map <leader>l <C-W>l

" tmux-like tab creation
map <leader>c :tabnew<cr>

" Map splits to be like tmux
map <leader>" :sp<cr>
map <leader>% :vsp<cr>

" Cope shortcuts
map <silent><c-n> :cn<cr>
map <silent><c-p> :cp<cr>

" Move between airline tabs
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Toggle paste mode
map <leader>p :setlocal paste!<cr>

" Use system clipboard
set clipboard=unnamed

" Call make
nnoremap <leader><cr> :make<cr>

" Toggle spellcheck
map <leader>s :setlocal spell!<cr>

" Highlight and replace current word cursor is on
nnoremap <leader>r :%s/<C-r><C-w>//gc<Left><Left><Left>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set Syntastic to passive for everything
let g:syntastic_mode_map = {
    \ "mode": "passive",
    \ "active_filetypes": [],
    \ "passive_filetypes": [] }

" Recommended Syntastic config
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Remap ctrlp so we can cycle modes with same key
let g:ctrlp_map = '<c-f>'
" ctrlp to stay in the first working directory it was invoked within, unless
" :cd command is issued to an outside dir
let g:ctrlp_working_path_mode = 'a'

" gitgutter behaves slowly when checking changes on context switch
let g:gitgutter_eager = 0
" Clear all default gitgutter mappings (default conflicts with <leader>h, etc)
let g:gitgutter_map_keys = 0
" Map useful gitgutter commands
nmap ]g <Plug>GitGutterNextHunk
nmap [g <Plug>GitGutterPrevHunk
nmap <leader>gu <Plug>GitGutterUndoHunk
nmap <leader>ga <Plug>GitGutterStageHunk

" Open Ag and put the cursor in the right position
nmap <leader>f :Ag!

" Run Ag search for current word cursor is on
nmap <leader>F :Ag!<c-r><c-w><cr>

" Open fugitive Git status
nmap <leader>gs :Gstatus<cr>

" Open fugitive Git blame
nmap <leader>gb :Gblame<cr>

" Load fugitive git history of file quickfix list and open in new tab
nmap <leader>gl :Glog<cr><cr>

" Load fugitive git diff of current file (need to add revision desired for
" diff, if any)
nmap <leader>gd :Gdiff<space>

" Open fugitive and load all commits touching current file into quickfix
nmap <leader>gc :Glog<space>--<space>%<cr><cr>

" Open NERDTree
nmap <leader>n :NERDTreeToggle<cr>
