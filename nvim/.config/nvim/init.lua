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
  -- improved quickfix/loclist behavior
  use 'romainl/vim-qf'
  -- use quickfix for include-search and definition-search with tags
  use 'romainl/vim-qlist'
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
  -- view git information in gutter
  use 'airblade/vim-gitgutter'
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
  -- comment out lines via motion
  --call minpac#add('tpope/vim-commentary')
  -- repeat support for various plugins
  use 'tpope/vim-repeat'
  -- enhanced time/date editing
  use 'tpope/vim-speeddating'

  -- searching
  -- TODO try fzf-lua
  -- hooks for fzf
  use 'junegunn/fzf.vim'
  -- adds extra info when searching
  use 'osyo-manga/vim-anzu'

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

vim.cmd('source ~/.config/nvim/vim_init.vim')

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

