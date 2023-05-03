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
  -- plantuml syntax highlighting
  use 'aklt/plantuml-syntax'
  -- colorize values
  use 'chrisbra/Colorizer'
  -- gcov syntax highlighting
  use 'hamsterjam/vim-gcovered'
  -- show and navigate marks
  use({
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup({
        default_mappings = true,
        signs = true,
        })
    end,
  })
  -- outline of code
  use({
    'stevearc/aerial.nvim',
    config = function()
      require('aerial').setup()
    end,
  })
  -- nvim treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  -- gruvbox theme
  use 'sainnhe/gruvbox-material'
  -- window pane resize mode
  use 'simeji/winresizer'
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
  use({
    'Wansmer/treesj',
    requires = { 'nvim-treesitter' },
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
        dot_repeat = true
        })
    end,
  })
  -- TODO: try hrsh7th/vim-vsnip
  -- snippet tool
  use 'joereynolds/vim-minisnip'
  -- align blocks of text
  use 'junegunn/vim-easy-align'
  -- add/change/delete surrounding char pairs
  use({
      "kylechui/nvim-surround",
      tag = "*", -- Use for stability; omit to use `main` branch for the latest features
      config = function()
          require("nvim-surround").setup({
              -- Configuration here, or leave empty to use defaults
          })
      end
  })
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
  -- lsp plugins
  use 'neovim/nvim-lspconfig'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
-- Setup language servers.
local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.clangd.setup{
  filetypes = { "c", "cpp" },
  init_options = {
    clangdFileStatus = false,
    usePlaceholders = false,
    completeUnimported = true,
    semanticHighlighting = false,
    showTodos = false,
  },
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = false,
        virtual_text = false,
        signs = false,
        update_in_insert = false,
      }
    ),
  },
}
-- load local rc files
vim.o.exrc = true

-- Set undo/backup/swap files to directory in home
vim.o.undodir = vim.fn.expand("~/.config/nvim/.undo//")
vim.o.backupdir = vim.fn.expand("~/.config/nvim/.backup//")
vim.o.directory = vim.fn.expand("~/.config/nvim/.swp//")

vim.o.undofile = true
vim.o.backup = true

vim.opt.clipboard:append("unnamedplus")

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

-- statusline

-- TODO: fix for gstatus showing stale time in other panes
-- local file_modification_time = function()
--   if vim.bo.buftype ~= 'nofile' then
--     local bufnr = vim.api.nvim_get_current_buf()
--     local ftime = vim.fn.getftime(vim.fn.bufname(bufnr))
--     return ftime ~= -1 and os.date('%m/%d/%y %H:%M', ftime) or ''
--   end
--   return ''
-- end
--
-- function my_statusline()
--   local branch = vim.fn.git_branch()
--   local workingdir = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
--   if branch and #branch > 0 then
--     branch = ' ├ '..branch
--   end
--
--   return ' %f%m ┃ '..workingdir..' ┃ '..branch..'%=%<%l,%c ┃ %P ┃ '..StatuslineModificationTime()
-- end
--
-- local working_dir = function()
--   return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
-- end
--
-- local git_branch = function()
--     if vim.g.loaded_fugitive then
--         local branch = vim.fn.FugitiveHead()
--         if branch ~= '' then return branch end
--     end
--     return ''
-- end
-- function status_line()
--     return table.concat {
--         "├ " .. git_branch(), -- branch name
--         " ┃ " .. working_dir(),
--         " ┃ %f%m ", -- spacing
--         "%=%<%l,%c ┃ %P ┃ ",
--         file_modification_time()
--     }
-- end

--vim.cmd[[ set statusline=%!luaeval('my_statusline()') ]]
--vim.opt.statusline = %{luaeval('my_statusline()')}
-- TODO: latest
--vim.opt.statusline = "%!v:lua.status_line()"

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

-- use patience diff algorithm
vim.o.diffopt = 'internal,algorithm:patience,indent-heuristic'

-- Helper function for custom keybinds
function map(mode, l, r, opts)
  opts = opts or {}
  vim.keymap.set(mode, l, r, opts)
end

-- TODO: get all gutters playing nice
-- vim.o.signcolumn="auto:2"

-- set external format tools based on filetype
-- TODO: move these to ftplugin dirs
vim.api.nvim_command("autocmd FileType c,cpp setlocal formatprg=clang-format\\ --assume-filename=%")
vim.api.nvim_command("autocmd FileType sh,bash setlocal makeprg=shellcheck\\ -f\\ gcc\\ %")

-- TODO: this is problematic, as it seems to not work with uncrustify after loading a 2nd buffer
-- run formatprg, retab, and trim whitespace on entire buffer
function AutoformatCurrentFile()
  local save = vim.fn.winsaveview()
  vim.cmd('execute "keepjumps normal! gggqG"')
  -- vim.cmd('retab')
  -- vim.cmd('keeppatterns %s/\\s\\+$//e')
  vim.fn.winrestview(save)
end

vim.g.winresizer_start_key='<leader>W'

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

-- wrapped movement
map('n', 'j', 'gj')
map('n', 'k', 'gk')

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
map('n', '<leader>gp', ':Gpush<cr>')
-- git commit
map('n', '<leader>gc', ':Gcommit -v<cr>')
-- write (essentially a write and git add)
map('n', '<leader>gw', ':Gwrite<cr>')
-- git diff of current file against HEAD
map('n', '<leader>gd', ':Gvdiff<cr>')
-- open git browser with all commits touching current file in new tab
map('n', '<leader>gh', ':Gclog<cr>')

-- toggle pane of tags
-- map('n', '<leader>T', ':SymbolsOutline<cr>')
-- You probably also want to set a keymap to toggle aerial
map('n', '<leader>tt', '<cmd>AerialToggle!<CR>')

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

-- split/join lines toggle
map('n', '<leader>j', require('treesj').toggle)

-- run formatter
map('n', '<leader>i', '<cmd>lua AutoformatCurrentFile()<cr>')

-- update plugins
map('n', '<leader>vu', ':PackerSync<cr>')

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- disable LSP formatting when using the |gq| command
    vim.bo[ev.buf].formatexpr = nil
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help)
    vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition)
    vim.keymap.set('n', '<leader>ln', vim.lsp.buf.rename)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.references)
  end,
})

vim.cmd('source ~/.config/nvim/vim_init.vim')
