" TODO: migrate to packer
packadd minpac
call minpac#init()
call minpac#add('k-takata/minpac', {'type': 'opt'})

" viewing
" plantuml syntax
call minpac#add('aklt/plantuml-syntax')
" colorize values
call minpac#add('chrisbra/Colorizer')
" gcov syntax highlighting
call minpac#add('hamsterjam/vim-gcovered')
" show and navigate marks
" TODO: replace w/ chentoast/marks.nvim?
call minpac#add('kshenoy/vim-signature')
" apply colors to different parentheses levels
call minpac#add('junegunn/rainbow_parentheses.vim')
" view tag information for current file
" TODO: replace w/ treesitter if possible?
call minpac#add('majutsushi/tagbar')
" nvim treesitter
call minpac#add('nvim-treesitter/nvim-treesitter', {'do': 'TSUpdate'})
" improved quickfix/loclist behavior
call minpac#add('romainl/vim-qf')
" use quickfix for include-search and definition-search with tags
call minpac#add('romainl/vim-qlist')
" gruvbox theme
call minpac#add('sainnhe/gruvbox-material')
" window pane resize mode
call minpac#add('simeji/winresizer')
" enhanced merge conflicts
call minpac#add('whiteinge/diffconflicts')
" TODO: setup another diff conflict tool
"Plug 'nvim-lua/plenary.nvim'
"Plug 'sindrets/diffview.nvim'
" diff entire folders
call minpac#add('will133/vim-dirdiff')
" TODO try rhysd/git-messenger.vim
"
" version control
" view git information in gutter
"call minpac#add('airblade/vim-gitgutter')
" run git commands, view status
call minpac#add('tpope/vim-fugitive')

" editing
" enhanced splitting and joining lines
call minpac#add('AndrewRadev/splitjoin.vim')
" snippet tool
call minpac#add('joereynolds/vim-minisnip')
" align blocks of text
call minpac#add('junegunn/vim-easy-align')
" add/change/delete surrounding char pairs
call minpac#add('machakann/vim-sandwich')
" reorder delimited items
call minpac#add('machakann/vim-swap')
" enhanced replace/substitution
call minpac#add('svermeulen/vim-subversive')
" swap text using motions
call minpac#add('tommcdo/vim-exchange')
" advanced substitution
call minpac#add('tpope/vim-abolish')
" comment out lines via motion
"call minpac#add('tpope/vim-commentary')
" repeat support for various plugins
call minpac#add('tpope/vim-repeat')
" enhanced time/date editing
call minpac#add('tpope/vim-speeddating')

" searching
" TODO try fzf-lua
" hooks for fzf
call minpac#add('junegunn/fzf.vim')
" adds extra info when searching
call minpac#add('osyo-manga/vim-anzu')

" other
" view/edit hex data
call minpac#add('fidian/hexmode')
" opens term or file manager of current file
call minpac#add('justinmk/vim-gtfo')
" open dev docs site for current word
call minpac#add('romainl/vim-devdocs')
" call commands async
call minpac#add('skywind3000/asyncrun.vim')
" enhanced tmux support/commands
call minpac#add('tpope/vim-tbone')
" extra keymaps
call minpac#add('tpope/vim-unimpaired')
" auto generate doxygen documentation
call minpac#add('vim-scripts/DoxygenToolkit.vim')
" vim manpager
call minpac#add('vim-utils/vim-man')
" lsp plugins
call minpac#add('neovim/nvim-lspconfig')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" map leader to space
nnoremap <Space> <nop>
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" true color support
set termguicolors

" themes
set background=dark
let g:gruvbox_material_foreground='original'
let g:gruvbox_material_background='hard'
colorscheme gruvbox-material

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

set showcmd

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set undo/backup/swap files to directory in home
set undodir=~/.config/nvim/.undo//
set backupdir=~/.config/nvim/.backup//
set directory=~/.config/nvim/.swp//
set viminfo+=n~/.config/nvim/viminfo

set undofile
set backup

" reload vimrc
nnoremap <leader>vv :source $MYVIMRC<CR>

" automatially reload file if shell command is run inside vim
set autoread

" reload current buffer only if there are no edits
nnoremap <leader>e :edit<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" use spaces instead of tabs
set expandtab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

" set external format tools based on filetype
autocmd FileType c,cpp setlocal formatprg=clang-format\ --assume-filename=%
autocmd FileType sh,bash setlocal makeprg=shellcheck\ -f\ gcc\ %

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set clipboard+=unnamedplus

" De-dupe and sort visual selection
vnoremap <leader>ds :'<,'>sort u<cr>

" yank filename to clipboard
nnoremap <leader>yf :let @+=expand("%:t")<CR>
" yank file path relative to current vim dir to clipboard
nnoremap <leader>yr :let @+=expand("%:p:.")<CR>
" yank absolutely file path to clipboard
nnoremap <leader>ya :let @+=expand("%:p")<CR>

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
nmap <leader>ww :tabe ~/wiki/index.md<cr>:lcd %:p:h<cr>

" change current window directory to current file
nmap <leader>wc :lcd %:p:h<cr>

" all cscope results go to quickfix and not wonky number-driven list
set cscopequickfix=s-,g-,d-,c-,t-,e-,f-,i-,a-

" set ripgrep as grep program
set grepprg=rg\ --vimgrep\ --smart-case
set grepformat=%f:%l:%c:%m
command! -nargs=+ Grep execute 'silent grep! <args>' | execute ':redraw!'
" ripgrep, but include all hidden/ignored files
command! -nargs=+ GrepAll execute 'silent grep! <args> -uu' | execute ':redraw!'

" quick-execute macro q
nnoremap Q @q

" use patience diff algorithm
set diffopt=internal,algorithm:patience,indent-heuristic

" open corresponding .h file of current .c file and vice-versa
map <leader>h :e %:p:s,.h$,.X1X,:s,.c$,.h,:s,.X1X$,.c,<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Debugging
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap ,b :Break<cr>
nnoremap ,d :Clear<cr>
nnoremap ,s :Step<cr>
nnoremap ,S :Source<cr>
nnoremap ,C :Stop<cr>
nnoremap ,n :Over<cr>
nnoremap ,f :Finish<cr>
nnoremap ,c :Continue<cr>
nnoremap ,p :Evaluate<cr>
nnoremap ,g :Gdb<cr>

" dark blue program counter when debugging
hi debugPC term=bold ctermbg=darkblue guibg=darkblue

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

" asyncrun
" stop asyncrun, redraw, and disable highlighting
nmap <leader><esc> :AsyncStop<cr>:redraw!<cr>:noh<cr>
nmap <leader>/ :Grep ""<left>
nmap <leader>? :GrepAll ""<left>
nmap <leader>f :Grep "<c-r><c-w>"<cr>
nmap <leader>F :GrepAll "<c-r><c-w>"<cr>
" search for all todo/fixme and put into quickfix list
nmap <leader>T :AsyncRun -program=grep '(TODO\|FIXME)'<cr>
" Run last make command
nmap <leader>mr :make<up><cr>
" Run make
nmap <leader>mm :silent make!<cr>:redraw!<cr>
" async make clean
nmap <leader>mc :Make clean<cr>
" generate ctags and gtags
nmap <leader>j :AsyncRun ctags -R .<cr>
" TODO: Figure out how to also plug in loading the cscope database
nmap ,tg :AsyncRun gtags<cr>
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
" git push
nmap <leader>gp :Gpush<cr>
" git commit
nmap <leader>gc :Gcommit<space>-v<cr>
" write (essentially a write and git add)
nmap <leader>gw :Gwrite<cr>
" git diff of current file against HEAD
nmap <leader>gd :Gvdiff<cr>
" open git browser with all commits touching current file in new tab
nmap <leader>gh :0Gclog<cr>

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
" open fzf for all files
nmap <leader>o :Files<cr>
" open fzf for all buffers
nmap <leader>ao :Buffers<cr>
" open fzf of lines in all buffers
nmap <leader>as :Lines<cr>
" open fzf of lines in current buffer
nmap <leader>aa :BLines<cr>
" open fzf of modified files tracked by git
nmap <leader>ag :GFiles?<cr>
" open fzf of ctags
nmap <leader>at :Tags<cr>
" start fzf-piped Rg search
nmap <leader>af :Rg<Space>
" use fzf for path completion
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('fd')

" use fd for FZF (which respects .gitignore)
let $FZF_DEFAULT_COMMAND = 'fd --type f --color=never'
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8, 'xoffset': 1 } }

" minpac
" update plugins
nmap <leader>vu :call minpac#update()<cr>
" clean plugins
nmap <leader>vc :call minpac#clean()<cr>

" vim-minisnip
" remap minisnip default trigger
let g:minisnip_trigger = '<c-s>'

" winresizer
" Enter resizer mode
let g:winresizer_start_key = '<leader>W'

" vim-sandwich
" use vim-surround keymaps (e.g. `ys`, `yss`, `yS`, `ds`, `cs` in normal mode and `S` in visual mode)
runtime macros/sandwich/keymap/surround.vim

" vim-subversive
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)
nmap <leader>s <plug>(SubversiveSubstituteRangeConfirm)
xmap <leader>s <plug>(SubversiveSubstituteRangeConfirm)
nmap <leader>ss <plug>(SubversiveSubstituteWordRangeConfirm)
" Use abolish's subvert to replace but preserve case
nmap <leader><leader>s <plug>(SubversiveSubvertRange)
xmap <leader><leader>s <plug>(SubversiveSubvertRange)
nmap <leader><leader>ss <plug>(SubversiveSubvertWordRange)

" vim-devdocs
" look up current word cursor is on in devdocs.io
nmap <leader>k :DD <c-r><c-w><cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Last
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" load machine-specific configs/overrides
try
  source ~/.vim/vimrc-local
catch
endtry