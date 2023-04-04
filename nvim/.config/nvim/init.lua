-- Install packer if needed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

-- maps leader to space
vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', '<space>', '<nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>', '<space>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<leader>', '<space>', { noremap = true, silent = true })

local packer_bootstrap = ensure_packer()

-- Plugins
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- My plugins here
  use 'aklt/plantuml-syntax'
  -- colorize values
  use 'chrisbra/Colorizer'
  -- gcov syntax highlighting
  use 'hamsterjam/vim-gcovered'
  -- show and navigate marks
  -- TODO: replace w/ chentoast/marks.nvim?
  use 'kshenoy/vim-signature'
  -- apply colors to different parentheses levels
  use 'junegunn/rainbow_parentheses.vim'
  -- view tag information for current file
  -- TODO: replace w/ treesitter if possible?
  use 'majutsushi/tagbar'
  -- nvim treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  -- gruvbox theme
  use 'sainnhe/gruvbox-material'
  -- window pane resize mode
  use 'simeji/winresizer'
  -- enhanced merge conflicts
  use 'whiteinge/diffconflicts'
  -- TODO: setup another diff conflict tool
  --Plug 'nvim-lua/plenary.nvim'
  --Plug 'sindrets/diffview.nvim'
  -- diff entire folders
  use 'will133/vim-dirdiff'
  -- TODO try rhysd/git-messenger.vim
  --
  -- version control
  -- view git information
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }

  -- run git commands, view status
  use 'tpope/vim-fugitive'

  -- editing
  -- enhanced splitting and joining lines
  use 'AndrewRadev/splitjoin.vim'
  -- TODO: try hrsh7th/vim-vsnip
  -- snippet tool
  use 'joereynolds/vim-minisnip'
  -- align blocks of text
  use 'junegunn/vim-easy-align'
  -- add/change/delete surrounding char pairs
  use 'machakann/vim-sandwich'
  -- reorder delimited items
  use 'machakann/vim-swap'
  -- enhanced replace/substitution
  use 'svermeulen/vim-subversive'
  -- swap text using motions
  use 'tommcdo/vim-exchange'
  -- advanced substitution
  use 'tpope/vim-abolish'
  -- comments
  use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
  }
  -- repeat support for various plugins
  use 'tpope/vim-repeat'
  -- enhanced time/date editing
  use 'tpope/vim-speeddating'

  -- searching
  -- TODO try fzf-lua
  -- hooks for fzf
  use 'junegunn/fzf.vim'

  -- other
  -- view/edit hex data
  use 'fidian/hexmode'
  -- opens term or file manager of current file
  use 'justinmk/vim-gtfo'
  -- open dev docs site for current word
  use 'romainl/vim-devdocs'
  -- call commands async
  use 'skywind3000/asyncrun.vim'
  -- enhanced tmux support/commands
  use 'tpope/vim-tbone'
  -- extra keymaps
  use 'tpope/vim-unimpaired'
  -- auto generate doxygen documentation
  use 'vim-scripts/DoxygenToolkit.vim'
  -- vim manpager
  use 'vim-utils/vim-man'
  -- lsp plugins
  use 'neovim/nvim-lspconfig'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- Set undo/backup/swap files to directory in home
vim.o.undodir = vim.fn.expand("~/.config/nvim/.undo//")
vim.o.backupdir = vim.fn.expand("~/.config/nvim/.backup//")
vim.o.directory = vim.fn.expand("~/.config/nvim/.swp//")

vim.o.undofile = true
vim.o.backup = true

-- Automatically reload file if shell command is run inside vim
vim.o.autoread = true


-- Use spaces instead of tabs
vim.o.expandtab = true

-- 1 tab == 2 spaces
vim.o.shiftwidth = 2
vim.o.tabstop = 2

-- Set termguicolors
vim.opt.termguicolors = true

-- Themes
vim.opt.background = "dark"
vim.g.gruvbox_material_foreground = 'original'
vim.g.gruvbox_material_background = 'hard'
vim.cmd('colorscheme gruvbox-material')

-- Dark blue program counter when debugging
vim.cmd('highlight debugPC term=bold ctermbg=darkblue guibg=darkblue')

-- Make Scons files show up as python
vim.cmd('autocmd BufNew,BufRead SConstruct,SConscript set filetype=python')

-- Make clang config files show up as yaml
vim.cmd('autocmd BufNew,BufRead .clang-format,.clang-tidy set filetype=yaml')

-- auto open quickfix when populated
vim.cmd('autocmd QuickFixCmdPost * copen')

-- Enable special doxygen highlighting
vim.g.load_doxygen_syntax = 1

-- Ignore compiled files
vim.o.wildignore = '*.o,*~,*.pyc,*.d'

-- Height of the command bar
vim.o.cmdheight = 2

-- How many tenths of a second to blink when matching brackets
vim.o.mat = 2

-- Line numbers
vim.wo.number = true

-- Disable scratch window preview in omni
vim.o.completeopt = vim.o.completeopt .. ',noselect'

-- Mouse setup
vim.o.mouse = 'a'

-- Cursor line/column highlighting
vim.wo.cursorline = true
vim.wo.cursorcolumn = true

-- Show 10 lines below/above cursor at all times
vim.o.scrolloff = 10

-- Use ripgrep as the search tool
vim.o.grepprg = 'rg --vimgrep --smart-case'
vim.o.grepformat = '%f:%l:%c:%m'

-- Use smartcase for inc searching
vim.o.ignorecase = true
vim.o.smartcase = true

-- Helper function for custom keybinds
function map(mode, l, r, opts)
  opts = opts or {}
  vim.keymap.set(mode, l, r, opts)
end

require('gitsigns').setup {
}

vim.o.signcolumn="auto:2",

-- Gitsigns Navigation
map('n', ']c', function()
  if vim.wo.diff then return ']c' end
  return ':Gitsigns next_hunk<CR>'
end, {expr=true})

map('n', '[c', function()
  if vim.wo.diff then return '[c' end
  return ':Gitsigns prev_hunk<CR>'
end, {expr=true})

-- Gitsigns Actions
map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
map('n', '<leader>hS', ':Gitsigns stage_buffer<CR>')
map('n', '<leader>hu', ':Gitsigns undo_stage_hunk<CR>')
map('n', '<leader>hR', ':Gitsigns reset_buffer<CR>')
map('n', '<leader>hp', ':Gitsigns preview_hunk<CR>')
map('n', '<leader>hb', ':Gitsigns blame_line<CR>')
map('n', '<leader>tb', ':Gitsigns toggle_current_line_blame<CR>')
map('n', '<leader>hd', ':Gitsigns diffthis<CR>')
map('n', '<leader>td', ':Gitsigns toggle_deleted<CR>')

-- Gitsigns Text object
map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "help", "query" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- reload vimrc
map('n', '<leader>vv', ':source $MYVIMRC<CR>')

-- reload current buffer only if there are no edits
map('n', '<leader>e', ':edit<cr>')

-- quick-execute macro q
map('n', 'Q', '@q')

-- tmux-like tab creation
map('n', '<leader>c', ':tabnew<cr>')

-- quickfix shortcuts
map('n', '<c-n>', ':cn<cr>')
map('n', '<c-p>', ':cp<cr>')

-- quick-map tabs
map('n', '<leader>1', '1gt')
map('n', '<leader>2', '2gt')
map('n', '<leader>3', '3gt')
map('n', '<leader>4', '4gt')
map('n', '<leader>5', '5gt')
map('n', '<leader>6', '6gt')
map('n', '<leader>7', '7gt')
map('n', '<leader>8', '8gt')
map('n', '<leader>9', '9gt')
map('n', '<leader>0', ':tablast<cr>')

-- remap ` jumping to ', since I never use the former
map('n', "'", "`")

-- vim-subversive
map('n', 's', '<plug>(SubversiveSubstitute)')
map('n', 'ss', '<plug>(SubversiveSubstituteLine)')
map('n', 'S', '<plug>(SubversiveSubstituteToEndOfLine)')
map('n', '<leader>s', '<plug>(SubversiveSubstituteRangeConfirm)')
map('x', '<leader>s', '<plug>(SubversiveSubstituteRangeConfirm)')
map('n', '<leader>ss', '<plug>(SubversiveSubstituteWordRangeConfirm)')
map('n', '<leader><leader>s', '<plug>(SubversiveSubvertRange)')
map('x', '<leader><leader>s', '<plug>(SubversiveSubvertRange)')
map('n', '<leader><leader>ss', '<plug>(SubversiveSubvertWordRange)')

-- vim-devdocs
-- look up current word cursor is on in devdocs.io
map('n', '<leader>k', ':DD <c-r><c-w><cr>')

-- git push
map('n', '<leader>gp', '<cmd>Gpush<cr>')
-- git commit
map('n', '<leader>gc', '<cmd>Gcommit -v<cr>')
-- write (essentially a write and git add)
map('n', '<leader>gw', '<cmd>Gwrite<cr>')
-- git diff of current file against HEAD
map('n', '<leader>gd', '<cmd>Gvdiff<cr>')
-- open git browser with all commits touching current file in new tab
map('n', '<leader>gh', '0Gclog<cr>')

-- tagbar
-- toggle pane of tags
map('n', '<leader>T', ':TagbarToggle<cr>')

-- hexmode
-- toggle Hexmode
map('n', '<leader>H', ':Hexmode<cr>')

-- highlight and replace current word cursor is on
map('n', '<leader>r', ':%s/<C-r><C-w>//gc<Left><Left><Left>', {silent = true})

-- set <c-d> to forward-delete in insert mode
map('i', '<c-d>', '<del>', {silent = true})

-- go up/down command history
map('c', '<c-j>', '<down>', {silent = true})
map('c', '<c-k>', '<up>', {silent = true})

-- yank/delete entire C-style functions
map('', '<leader>Y', 'Vf{%d', {silent = true})
map('', '<leader>D', 'Vf{%y', {silent = true})

-- open index in personal wiki
map('n', '<leader>ww', ':tabe ~/wiki/index.md<cr>:lcd %:p:h<cr>', {silent = true})

-- change current window directory to current file
map('n', '<leader>wc', ':lcd %:p:h<cr>', {silent = true})

-- vim-easy-align
-- start interactive EasyAlign in visual mode (e.g. vipga)
map('x', 'ga', '<Plug>(EasyAlign)')
-- start interactive EasyAlign for a motion/text object (e.g. gaip)
map('n', 'ga', '<Plug>(EasyAlign)')

-- rainbow_parentheses.vim
-- toggle rainbow parentheses
map('n', '<leader>P', ':RainbowParentheses!!<cr>')

-- replace in quickfix list what word the cursor is currently on
map('n', '<leader>R', ':cdo %s/<C-r><C-w>//gc<Left><Left><Left>')

-- fzf.vim
-- open fzf for all files
map('n', '<leader>o', ':Files<cr>')
-- open fzf for all buffers
map('n', '<leader>ao', ':Buffers<cr>')
-- open fzf of lines in all buffers
map('n', '<leader>as', ':Lines<cr>')
-- open fzf of lines in current buffer
map('n', '<leader>aa', ':BLines<cr>')
-- open fzf of modified files tracked by git
map('n', '<leader>ag', ':GFiles?<cr>')
-- open fzf of ctags
map('n', '<leader>at', ':Tags<cr>')
-- start fzf-piped Rg search
map('n', '<leader>af', ':Rg<Space>')


-- debugging
map('n', ',b', ':Break<cr>')
map('n', ',d', ':Clear<cr>')
map('n', ',s', ':Step<cr>')
map('n', ',S', ':Source<cr>')
map('n', ',C', ':Stop<cr>')
map('n', ',n', ':Over<cr>')
map('n', ',f', ':Finish<cr>')
map('n', ',c', ':Continue<cr>')
map('n', ',p', ':Evaluate<cr>')
map('n', ',g', ':Gdb<cr>')

vim.cmd('source ~/.config/nvim/vim_init.vim')
