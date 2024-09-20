-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- maps leader to space
vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', '<space>', '<nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>', '<space>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<leader>', '<space>', { noremap = true, silent = true })

-- Plugins
require("lazy").setup({
  -- plantuml syntax highlighting
  "aklt/plantuml-syntax",
  -- colorize values
  "chrisbra/Colorizer",
  -- gcov syntax highlighting
  "hamsterjam/vim-gcovered",
  -- diff/merge viewing
  "sindrets/diffview.nvim",
  -- show and navigate marks
  {
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup({
        default_mappings = true,
        signs = true,
      })
    end,
  },
  -- outline of code
  {
    'stevearc/aerial.nvim',
    config = function()
      require('aerial').setup()
    end,
  },
  -- nvim treesitter
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
  -- gruvbox theme
  'sainnhe/gruvbox-material',
  -- version control
  -- view git information
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },

  -- run git commands, view status
  'tpope/vim-fugitive',
  -- managing window splits
  'mrjones2014/smart-splits.nvim',

  -- editing
  -- enhanced splitting and joining lines
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter' },
    config = function()
      require('treesj').setup({
        use_default_keymaps = false,
        dot_repeat = true
      })
    end,
  },
  -- align blocks of text
  'junegunn/vim-easy-align',
  -- add/change/delete surrounding char pairs
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  -- reorder delimited items
  'machakann/vim-swap',
  -- enhanced replace/substitution
  'svermeulen/vim-subversive',
  -- swap text using motions
  'tommcdo/vim-exchange',
  -- advanced substitution
  'tpope/vim-abolish',
  -- repeat support for various plugins
  'tpope/vim-repeat',
  -- enhanced time/date editing
  'tpope/vim-speeddating',

  -- searching
  -- hooks for fzf
  {
    'ibhagwan/fzf-lua',
    config = function()
      require("fzf-lua").setup({})
    end
  },

  -- other
  -- view/edit hex data
  'fidian/hexmode',
  -- dap debugger
  { 
    "rcarriga/nvim-dap-ui", 
    dependencies = {
      "mfussenegger/nvim-dap", 
      "nvim-neotest/nvim-nio"
    }
  },
  -- neodev
  { "folke/neodev.nvim", opts = {} },
  -- bazel build integration w/ maktaba dep
  {
    'bazelbuild/vim-bazel',

    dependencies = {
      'google/vim-maktaba',
    }
  },
  -- opens term or file manager of current file
  'justinmk/vim-gtfo',
  -- open dev docs site for current word
  'romainl/vim-devdocs',
  -- call commands async
  'skywind3000/asyncrun.vim',
  -- enhanced tmux support/commands
  'tpope/vim-tbone',
  -- extra keymaps
  'tpope/vim-unimpaired',
  -- auto generate doxygen documentation
  'vim-scripts/DoxygenToolkit.vim',
  -- lsp plugins
  'neovim/nvim-lspconfig',
  -- markdown preview
  {
    "Tweekism/markdown-preview.nvim",
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.cmd [[Lazy load markdown-preview.nvim]]
      vim.fn['mkdp#util#install']()
    end,
  },

  -- autocompletion
  {
    "hrsh7th/nvim-cmp",
  },
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },
  {
    "zbirenbaum/copilot-cmp",

    config = function ()
      require("copilot_cmp").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },

})

-- nvim-cmp setup

-- used for copilot 
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end
local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- specify a snippet engine
    expand = function(args)
      vim.snippet.expand(args.body) -- use native neovim snippets
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end),
  },
  sources = {
    { name = "nvim_lsp", group_index = 1 },
    { name = "copilot", group_index = 2 },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

-- snippet binds
vim.keymap.set({ 'i', 's' }, '<Tab>', function()
   if vim.snippet.active({ direction = 1 }) then
     return '<cmd>lua vim.snippet.jump(1)<cr>'
   else
     return '<Tab>'
   end
 end, { expr = true })
vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
   if vim.snippet.active({ direction = -1 }) then
     return '<cmd>lua vim.snippet.jump(-1)<cr>'
   else
     return '<S-Tab>'
   end
 end, { expr = true })

-- The nvim-cmp almost supports LSP's capabilities so you should advertise it to LSP servers...
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- for responsiveness of lsp diagnostic windows
vim.o.updatetime = 250
-- diagnostic display settings
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

-- Setup language servers.
local lspconfig = require('lspconfig')
vim.api.nvim_create_autocmd("CursorHold", {
  buffer = bufnr,
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
    }
    vim.diagnostic.open_float(nil, opts)
  end
})
lspconfig.rust_analyzer.setup({
  -- Server-specific settings. See `:help lspconfig-setup`
  on_attach = function(client, bufnr)
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end,
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        runBuildScripts = true,
      },
      diagnostics = {
        enable = true;
      },
      -- Add clippy lints for Rust.
      checkOnSave = {
        allFeatures = true,
        command = "clippy",
        extraArgs = {
          "--",
          "--no-deps",
          "-Dclippy::correctness",
          "-Dclippy::complexity",
          "-Wclippy::perf",
          "-Wclippy::pedantic",
        },
      },
    },
  },
})
lspconfig.marksman.setup{}
lspconfig.pyright.setup{}
lspconfig.clangd.setup{
  capabilities = capabilities,
  filetypes = { "c", "cpp" },
  init_options = {
    clangdFileStatus = false,
    usePlaceholders = false,
    completeUnimported = true,
    semanticHighlighting = false,
    showTodos = false,
  },
  handlers = {},
}

-- neodev.nvim setup for type checking, autocomplete, etc.
require("neodev").setup({
  library = { plugins = { "nvim-dap-ui" }, types = true },
})

require("dapui").setup()

-- run dapui on dap events
local dap, dapui = require("dap"), require("dapui")
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

-- Setup nvim-dap debugger
local dap = require("dap")

dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "-i", "dap" }
}

dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
}

dap.configurations.rust = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
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

-- TODO: per https://gpanders.com/blog/whats-new-in-neovim-0.10/ nvim .10 supports OSC 52, but foot does not (yet?)
vim.opt.clipboard:append("unnamedplus")

-- Automatically reload file if shell command is run inside vim
vim.o.autoread = true

-- Use spaces instead of tabs
vim.o.expandtab = true

-- 1 tab == 2 spaces
vim.o.shiftwidth = 2
vim.o.tabstop = 2

-- Themes
vim.opt.background = "dark"
vim.g.gruvbox_material_foreground = 'original'
vim.g.gruvbox_material_background = 'hard'
vim.cmd('colorscheme gruvbox-material')

-- Make Scons files highlight as python
vim.cmd('autocmd BufNew,BufRead SConstruct,SConscript set filetype=python')

-- Make clang config highlight as yaml
vim.cmd('autocmd BufNew,BufRead .clang-format,.clang-tidy set filetype=yaml')

-- Make systemd service files highlight as gitconfig files
vim.cmd('autocmd BufNew,BufRead *.service set filetype=gitconfig')

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

-- maximum 2 signs in signcolumn
vim.opt.signcolumn="auto:2"

-- set external format tools based on filetype
-- TODO: move these to ftplugin dirs
vim.api.nvim_command("autocmd FileType c,cpp setlocal formatprg=clang-format\\ --assume-filename=%")
vim.api.nvim_command("autocmd FileType sh,bash setlocal makeprg=shellcheck\\ -f\\ gcc\\ %")

-- TODO: this is problematic, as it seems to not work with uncrustify after loading a 2nd buffer
-- run formatprg, retab, and trim whitespace on entire buffer
function AutoformatCurrentFile()
  local save = vim.fn.winsaveview()
  vim.cmd('execute "keepjumps normal! gggqG"')
  vim.fn.winrestview(save)
end

-- automatically resize windows when the host window size changes (e.g. tmux pane resize)
local wr_group = vim.api.nvim_create_augroup('WinResize', { clear = true })
vim.api.nvim_create_autocmd(
    'VimResized',
    {
        group = wr_group,
        pattern = '*',
        command = 'wincmd =',
        desc = 'Automatically resize windows when the host window size changes.'
    }
)

-- Gitsigns Navigation
vim.keymap.set('n', ']c', function()
  if vim.wo.diff then return ']c' end
  return ':Gitsigns next_hunk<CR>'
end, {expr=true})

vim.keymap.set('n', '[c', function()
  if vim.wo.diff then return '[c' end
  return ':Gitsigns prev_hunk<CR>'
end, {expr=true})

-- Gitsigns Actions
vim.keymap.set({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
vim.keymap.set({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
vim.keymap.set('n', '<leader>hS', ':Gitsigns stage_buffer<CR>')
vim.keymap.set('n', '<leader>hu', ':Gitsigns undo_stage_hunk<CR>')
vim.keymap.set('n', '<leader>hR', ':Gitsigns reset_buffer<CR>')
vim.keymap.set('n', '<leader>hp', ':Gitsigns preview_hunk<CR>')
vim.keymap.set('n', '<leader>hb', ':Gitsigns blame_line<CR>')
vim.keymap.set('n', '<leader>hd', ':Gitsigns diffthis<CR>')
vim.keymap.set('n', '<leader>td', ':Gitsigns toggle_deleted<CR>')

-- Gitsigns Text object
vim.keymap.set({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "query", "markdown" },

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
vim.keymap.set('n', '<leader>vv', ':source $MYVIMRC<CR>')

-- reload current buffer only if there are no edits
vim.keymap.set('n', '<leader>e', ':edit<cr>')

-- tmux-like tab creation
vim.keymap.set('n', '<leader>c', ':tabnew<cr>')

-- quickfix shortcuts
vim.keymap.set('n', '<c-n>', ':cn<cr>')
vim.keymap.set('n', '<c-p>', ':cp<cr>')

-- wrapped movement
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- quick-map tabs
vim.keymap.set('n', '<leader>1', '1gt')
vim.keymap.set('n', '<leader>2', '2gt')
vim.keymap.set('n', '<leader>3', '3gt')
vim.keymap.set('n', '<leader>4', '4gt')
vim.keymap.set('n', '<leader>5', '5gt')
vim.keymap.set('n', '<leader>6', '6gt')
vim.keymap.set('n', '<leader>7', '7gt')
vim.keymap.set('n', '<leader>8', '8gt')
vim.keymap.set('n', '<leader>9', '9gt')
vim.keymap.set('n', '<leader>0', ':tablast<cr>')

-- remap ` jumping to ', since I never use the former
vim.keymap.set('n', "'", "`")

-- vim-subversive
vim.keymap.set('n', 's', '<plug>(SubversiveSubstitute)')
vim.keymap.set('n', 'ss', '<plug>(SubversiveSubstituteLine)')
vim.keymap.set('n', 'S', '<plug>(SubversiveSubstituteToEndOfLine)')
vim.keymap.set('n', '<leader>s', '<plug>(SubversiveSubstituteRangeConfirm)')
vim.keymap.set('x', '<leader>s', '<plug>(SubversiveSubstituteRangeConfirm)')
vim.keymap.set('n', '<leader>ss', '<plug>(SubversiveSubstituteWordRangeConfirm)')
vim.keymap.set('n', '<leader><leader>s', '<plug>(SubversiveSubvertRange)')
vim.keymap.set('x', '<leader><leader>s', '<plug>(SubversiveSubvertRange)')
vim.keymap.set('n', '<leader><leader>ss', '<plug>(SubversiveSubvertWordRange)')

-- De-dupe and sort visual selection
vim.keymap.set('v', '<leader>ds', ':\'<,\'>sort u<cr>')

-- yank filename to clipboard
vim.keymap.set('n', '<leader>yf', ':let @+=expand("%:t")<CR>')
-- yank file path relative to current vim dir to clipboard
vim.keymap.set('n', '<leader>yr', ':let @+=expand("%:p:.")<CR>')
-- yank absolute file path to clipboard
vim.keymap.set('n', '<leader>ya', ':let @+=expand("%:p")<CR>')

-- vim-devdocs
-- look up current word cursor is on in devdocs.io
vim.keymap.set('n', '<leader>k', ':DD <c-r><c-w><cr>')

-- git push
vim.keymap.set('n', '<leader>gp', ':Gpush<cr>')
-- git commit
vim.keymap.set('n', '<leader>gc', ':Gcommit -v<cr>')
-- write (essentially a write and git add)
vim.keymap.set('n', '<leader>gw', ':Gwrite<cr>')
-- git diff of current file against HEAD
vim.keymap.set('n', '<leader>gd', ':Gvdiff<cr>')
-- open git browser with all commits touching current file in new tab
vim.keymap.set('n', '<leader>gh', ':Gclog<cr>')

-- toggle pane of tags
-- map('n', '<leader>T', ':SymbolsOutline<cr>')
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set('n', '<leader>tt', '<cmd>AerialToggle!<CR>')

-- hexmode
-- toggle Hexmode
vim.keymap.set('n', '<leader>H', ':Hexmode<cr>')

-- highlight and replace current word cursor is on
vim.keymap.set('n', '<leader>r', ':%s/<C-r><C-w>//gc<Left><Left><Left>', {silent = true})

-- set <c-d> to forward-delete in insert mode
vim.keymap.set('i', '<c-d>', '<del>', {silent = true})

-- go up/down command history
vim.keymap.set('c', '<c-j>', '<down>', {silent = true})
vim.keymap.set('c', '<c-k>', '<up>', {silent = true})

-- open index in personal wiki
vim.keymap.set('n', '<leader>ww', ':tabe ~/wiki/index.md<cr>:lcd %:p:h<cr>', {silent = true})

-- change current window directory to current file
vim.keymap.set('n', '<leader>wc', ':lcd %:p:h<cr>', {silent = true})

-- Enter window resize mode
vim.keymap.set('n', '<leader>W', ':SmartResizeMode<cr>')

-- vim-easy-align
-- start interactive EasyAlign in visual mode (e.g. vipga)
vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)')
-- start interactive EasyAlign for a motion/text object (e.g. gaip)
vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)')

-- replace in quickfix list what word the cursor is currently on
vim.keymap.set('n', '<leader>R', ':cdo %s/<C-r><C-w>//gc<Left><Left><Left>')

-- fzf.vim
-- open fzf for all files
vim.keymap.set('n', '<leader>o', ':FzfLua files<cr>')
-- open fzf for all buffers
vim.keymap.set('n', '<leader>ao', ':FzfLua buffers<cr>')
-- open fzf of lines in all buffers
vim.keymap.set('n', '<leader>as', ':FzfLua lines<cr>')
-- open fzf of lines in current buffer
vim.keymap.set('n', '<leader>aa', ':FzfLua blines<cr>')
-- open fzf of modified files tracked by git
vim.keymap.set('n', '<leader>ag', ':FzfLua git_files<cr>')
-- open fzf of ctags
vim.keymap.set('n', '<leader>at', ':FzfLua tags<cr>')
-- start fzf-piped Rg search
vim.keymap.set('n', '<leader>af', ':FzfLua grep<cr>')
-- start fzf-piped live Rg search
vim.keymap.set('n', '<leader>al', ':FzfLua live_grep<cr>')

-- debugging
--
vim.keymap.set('n', ',c', function() require('dap').continue() end)
vim.keymap.set('n', ',o', function() require('dap').step_over() end)
vim.keymap.set('n', ',s', function() require('dap').step_into() end)
vim.keymap.set('n', ',S', function() require('dap').step_out() end)
vim.keymap.set('n', ',b', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', ',r', function() require('dap').repl.open() end)
vim.keymap.set('n', ',dl', function() require('dap').run_last() end)
vim.keymap.set({'n', 'v'}, ',h', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set({'n', 'v'}, ',p', function()
  require('dap.ui.widgets').preview()
end)

-- split/join lines toggle
vim.keymap.set('n', '<leader>j', require('treesj').toggle)

-- run formatter
vim.keymap.set('n', '<leader>i', '<cmd>lua AutoformatCurrentFile()<cr>')

-- update plugins
vim.keymap.set('n', '<leader>vu', ':Lazy sync<cr>')

-- vim-fugitive
-- blame
vim.keymap.set('n', '<leader>gb', ':Git blame<cr>')
-- status
vim.keymap.set('n', '<leader>gs', ':Git <cr>')

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
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help)
    vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename)
    vim.keymap.set('n', '<leader>lf', vim.lsp.buf.references)
    -- perform suggested fix
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action)
    vim.keymap.set('n', '<leader>lh', ':ClangdSwitchSourceHeader<cr>')
  end,
})

-- Toggle diagnostics
vim.g["diagnostics_active"] = true
function Toggle_diagnostics()
    if vim.g.diagnostics_active then
        vim.g.diagnostics_active = false
        vim.diagnostic.disable()
    else
        vim.g.diagnostics_active = true
        vim.diagnostic.enable()
    end
end

vim.keymap.set('n', '<leader>ll', Toggle_diagnostics, { noremap = true, silent = true, desc = "Toggle vim diagnostics" })

-- Explain current text selection
vim.keymap.set('v', '<leader>le', ':\'<,\'>CopilotChatExplain <cr>', { noremap = true, silent = true, desc = "CopilotChat - Explain visual selection"})

-- Quick chat with Copilot of current buffer
vim.keymap.set('n', "<leader>lc",
    function()
      local input = vim.fn.input("Quick Chat: ")
      if input ~= "" then
        require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
      end
    end,
    { noremap = true, silent = true, desc = "CopilotChat - Quick chat"}
    )

--show a sign for the highest severity diagnostic on a given line:
-- Create a custom namespace. This will aggregate signs from all other
-- namespaces and only show the one with the highest severity on a
-- given line
local ns = vim.api.nvim_create_namespace("my_namespace")

-- Get a reference to the original signs handler
local orig_signs_handler = vim.diagnostic.handlers.signs

-- Override the built-in signs handler
vim.diagnostic.handlers.signs = {
  show = function(_, bufnr, _, opts)
    -- Get all diagnostics from the whole buffer rather than just the
    -- diagnostics passed to the handler
    local diagnostics = vim.diagnostic.get(bufnr)

    -- Find the "worst" diagnostic per line
    local max_severity_per_line = {}
    for _, d in pairs(diagnostics) do
      local m = max_severity_per_line[d.lnum]
      if not m or d.severity < m.severity then
        max_severity_per_line[d.lnum] = d
      end
    end

    -- Pass the filtered diagnostics (with our custom namespace) to
    -- the original handler
    local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
    orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
  end,
  hide = function(_, bufnr)
    orig_signs_handler.hide(ns, bufnr)
  end,
}

vim.cmd('source ~/.config/nvim/vim_init.vim')
