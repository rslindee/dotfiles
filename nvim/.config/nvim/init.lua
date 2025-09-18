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
  -- manage window splits
  {
    'mrjones2014/smart-splits.nvim',
    dependencies = {
      'pogyomo/submode.nvim',
    },
    config = function()
      -- Resize submode
      local submode = require 'submode'
      submode.create('WinResize', {
        mode = 'n',
        enter = '<C-w>r',
        leave = { '<Esc>', 'q', '<C-c>' },
        hook = {
          on_enter = function()
            vim.notify 'Use { h, j, k, l } to resize the window'
          end,
          on_leave = function()
            vim.notify ''
          end,
        },
        default = function(register)
          register('h', require('smart-splits').resize_left, { desc = 'Resize left' })
          register('j', require('smart-splits').resize_down, { desc = 'Resize down' })
          register('k', require('smart-splits').resize_up, { desc = 'Resize up' })
          register('l', require('smart-splits').resize_right, { desc = 'Resize right' })
        end,
      })
    end,
  },

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
  -- TODO: replace with overseer
  -- call commands async
  'skywind3000/asyncrun.vim',
  -- enhanced tmux support/commands
  'tpope/vim-tbone',
  -- extra keymaps
  'tpope/vim-unimpaired',
  -- repeatable movements
  {
    "ghostbuster91/nvim-next",
    config = function ()
      require("nvim-next").setup({
       default_mappings = {
           repeat_style = "original",
       }
      })
    end
  },
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
  -- markdown toc generation
  {
    "richardbizik/nvim-toc",
    config = function ()
      require("nvim-toc").setup({
        toc_header = "Table of Contents"
      })
    end
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
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken",
    opts = {
      debug = true, -- Enable debugging
      model = "gpt-4.1",
      sticky = {"#buffer", "#gitdiff"},
      -- See Configuration section for rest
      window = {
        layout = 'vertical', -- 'vertical', 'horizontal', 'float', 'replace'
        width = 0.3, -- fractional width of parent, or absolute width in columns when > 1
        height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
        -- Options below only apply to floating windows
        relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
        border = 'single', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        row = nil, -- row position of the window, default is centered
        col = nil, -- column position of the window, default is centered
        title = 'Copilot Chat', -- title of chat window
        footer = nil, -- footer of chat window
        zindex = 1, -- determines if window is on top or below other floating windows
      },
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
  -- statusline plugin
  "rebelot/heirline.nvim",
  -- lsp status
  {
    'linrongbin16/lsp-progress.nvim',
    config = function()
      require('lsp-progress').setup()
    end
  },
  -- enhanced search
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  }

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
vim.lsp.set_log_level("ERROR")
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
-- rust lsp
vim.lsp.config('rust_analyzer', {
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
vim.lsp.enable({'rust_analyzer'})
-- markdown lsp
vim.lsp.config('marksman', {})
vim.lsp.enable({'marksman'})
-- python lsp
vim.lsp.config('pyright', {})
vim.lsp.enable({'pyright'})
-- clang lsp
vim.lsp.config('clangd', {
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
})
vim.lsp.enable({'clangd'})
-- protocol buffers lsp
vim.lsp.config('protols', {})
vim.lsp.enable({'protols'})
-- grammar lsp
vim.lsp.config('harper_ls', {
  settings = {
    ["harper-ls"] = {
      linters = {
        SentenceCapitalization = false,
        SpellCheck = false,
        ToDoHyphen = false,
      }
    }
  }
})
vim.lsp.enable({'harper_ls'})

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
vim.o.softtabstop = 2 -- Number of spaces inserted instead of a TAB character
vim.opt_local.expandtab = true

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

-- heirline
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local Ruler = {
    -- %l = current line number
    -- %c = column number
    -- %P = percentage through file of displayed window
    provider = "%l,%c %P",
}

local FileLastModified = {
    provider = function()
        local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
        return (ftime > 0) and os.date('%m/%d/%y %H:%M', ftime)
    end
}

local Git = {
  condition = conditions.is_git_repo,

  init = function(self)
      self.status_dict = vim.b.gitsigns_status_dict
      self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,

  {   -- git branch name
    provider = function(self)
        return " ┃ ├" .. self.status_dict.head
    end,
  },
}

local FileNameBlock = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,
}

local FileName = {
    provider = function(self)
        -- first, trim the pattern relative to the current directory. For other
        -- options, see :h filename-modifers
        local filename = vim.fn.fnamemodify(self.filename, ":.")
        if filename == "" then return "[No Name]" end
        -- if the filename would occupy more than a specified fraction of the available
        -- space, we trim the file path to its initials
        -- See Flexible Components section below for dynamic truncation
        if not conditions.width_percent_below(#filename, 0.4) then
            filename = vim.fn.pathshorten(filename)
        end
        return filename
    end,
}

local FileFlags = {
    {
        condition = function()
            return vim.bo.modified
        end,
        provider = "[+]",
    },
    {
        condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = "[-]",
    },
}


local WorkingDir = {
  provider = function()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
  end
}

local FileNameBlock = utils.insert(FileNameBlock,
    utils.insert(FileName), -- a new table where FileName is a child of FileNameModifier
    FileFlags,
    { 
      provider = '%<',
  } -- this means that the statusline is cut here when there's not enough space

)
local LspProgress = {
  provider = function()
    return require('lsp-progress').progress({
      format = function(messages)
        -- icon: nf-fa-gear \uf013
        local sign = " ┃ LSP"
        if #messages > 0 then
            return sign .. " "
        end
        local active_clients = vim.lsp.get_clients()
        if #active_clients > 0 then
            return sign
        end
        return ""
      end,
    })
  end,
  update = {
    'User',
    pattern = 'LspProgressStatusUpdated',
    callback = vim.schedule_wrap(function()
      vim.cmd('redrawstatus')
    end),
  }
}

local StatusLine = {
  FileNameBlock,
  { provider = " ┃ " },
  WorkingDir,
  Git,
  LspProgress,
  { provider = "%=" }, -- align right
  Ruler,
  { provider = " ┃ " },
  FileLastModified
}


require("heirline").setup({
    statusline = StatusLine,
})
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

-- Mouse-selected text copies to primary selection clipboard
vim.api.nvim_create_autocmd("CursorMoved", {
  desc = "Keep * synced with selection",
  callback = function()
    local mode = vim.fn.mode(false)
    if mode == "v" or mode == "V" or mode == "^V" then
      vim.cmd([[silent norm "*ygv]])
    end
  end,
})

-- set external format tools based on filetype
-- TODO: move these to ftplugin dirs
vim.api.nvim_command("autocmd FileType c,cpp setlocal formatprg=clang-format\\ --assume-filename=%")
vim.api.nvim_command("autocmd FileType sh,bash setlocal makeprg=shellcheck\\ -f\\ gcc\\ %")

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
-- toggle quickfix list
local function toggle_quickfix()
  local windows = vim.fn.getwininfo()
  for _, win in pairs(windows) do
    if win["quickfix"] == 1 then
      vim.cmd.cclose()
      return
    end
  end
  vim.cmd.copen()
end

vim.keymap.set('n', '<Leader>q', toggle_quickfix, { desc = "Toggle Quickfix Window" })

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
-- print file path relative to current vim dir
vim.keymap.set('n', '<leader>Y', ':echo expand("%:p:.")<CR>')

-- vim-devdocs
-- look up current word cursor is on in devdocs.io
vim.keymap.set('n', '<leader>kd', ':DD <c-r><c-w><cr>')

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

-- toggle tag pane
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
-- open fzf of treesitter symbols of current buffer
vim.keymap.set('n', '<leader>at', ':FzfLua treesitter<cr>')
-- start fzf-piped Rg search
vim.keymap.set('n', '<leader>af', ':FzfLua grep<cr>')
-- start fzf-piped live Rg search
vim.keymap.set('n', '<leader>al', ':FzfLua live_grep<cr>')

-- asyncrun
-- stop asyncrun, redraw, and disable highlighting
vim.api.nvim_set_keymap('n', '<leader><esc>', ':AsyncStop<CR>:redraw!<CR>:noh<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>/', ':silent! grep ""<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>?', ':GrepAll ""<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f', ':silent! grep "<C-R><C-W>"<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>F', ':GrepAll "<C-R><C-W>"<CR>', { noremap = true, silent = true })
-- search for all todo/fixme and put into quickfix list
-- vim.api.nvim_set_keymap('n', '<leader>T', ':AsyncRun -program=grep \'(TODO\\|FIXME)\'<CR>', { noremap = true, silent = true })
-- Run last make command
vim.api.nvim_set_keymap('n', '<leader>mr', ':make<Up><CR>', { noremap = true, silent = true })
-- Run make
vim.api.nvim_set_keymap('n', '<leader>mm', ':silent make!<CR>:redraw!<CR>', { noremap = true, silent = true })
-- make clean
vim.api.nvim_set_keymap('n', '<leader>mc', ':make clean<CR>', { noremap = true, silent = true })
-- make test
vim.api.nvim_set_keymap('n', '<leader>mt', ':make test<CR>', { noremap = true, silent = true })
-- run whatever defined makeprg
vim.api.nvim_set_keymap('n', '<leader>ml', ':AsyncRun -program=make %<CR>', { noremap = true, silent = true })

-- Misc
-- use ripgrep, but include all hidden/ignored files
vim.api.nvim_create_user_command('GrepAll', function(opts)
  vim.cmd('silent grep! ' .. table.concat(opts.fargs, ' ') .. ' -uu')
  vim.cmd('redraw!')
end, { nargs = '+' })

-- make asyncrun work with vim-fugitive
vim.api.nvim_create_user_command('Make', function(opts)
  vim.cmd('AsyncRun -program=make @ ' .. table.concat(opts.fargs, ' '))
end, { bang = true, nargs = '*', complete = 'file' })

vim.api.nvim_create_user_command('Gpush', function(opts)
  local git_dir = vim.fn.fnameescape(vim.fn.FugitiveGitDir())
  vim.cmd('AsyncRun' .. (opts.bang and '!' or '') .. ' -cwd=' .. git_dir .. ' git push ' .. table.concat(opts.fargs, ' '))
end, { bang = true, bar = true, nargs = '*' })

vim.api.nvim_create_user_command('Gfetch', function(opts)
  local git_dir = vim.fn.fnameescape(vim.fn.FugitiveGitDir())
  vim.cmd('AsyncRun' .. (opts.bang and '!' or '') .. ' -cwd=' .. git_dir .. ' git fetch ' .. table.concat(opts.fargs, ' '))
end, { bang = true, bar = true, nargs = '*' })

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

-- map esc when in terminal mode
vim.keymap.set('t', '<esc>', '<C-\\><C-n>')

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
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help)
    vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition)
    vim.keymap.set('n', '<leader>lh', ':ClangdSwitchSourceHeader<cr>')
  end,
})

vim.keymap.set('n', '<leader>ll', function() 
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { noremap = true, silent = true, desc = "Toggle vim diagnostics" })

-- Explain current text selection
vim.keymap.set('v', '<leader>ke', ':\'<,\'>CopilotChatExplain <cr>', { noremap = true, silent = true, desc = "CopilotChat - Explain visual selection"})

-- Review selected code
vim.keymap.set('v', '<leader>kr', ':\'<,\'>CopilotChatReview <cr>', { noremap = true, silent = true, desc = "CopilotChat - Review visual selection"})

-- Fix selected code
vim.keymap.set('v', '<leader>kf', ':\'<,\'>CopilotChatFix <cr>', { noremap = true, silent = true, desc = "CopilotChat - Fix visual selection"})

-- Optimize selected code
vim.keymap.set('v', '<leader>ko', ':\'<,\'>CopilotChatOptimize <cr>', { noremap = true, silent = true, desc = "CopilotChat - Optimize visual selection"})

-- Document selected code
vim.keymap.set('v', '<leader>kd', ':\'<,\'>CopilotChatDocs <cr>', { noremap = true, silent = true, desc = "CopilotChat - Document visual selection"})

-- Quick chat keybinding
vim.keymap.set('n', '<leader>kc', function()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    require("CopilotChat").ask(input, {
      selection = require("CopilotChat.select").buffer
    })
  end
end, { desc = "CopilotChat - Quick chat" })

-- Quick chat with Copilot about the current visual selection
vim.keymap.set('v', '<leader>kv',
    function()
      local input = vim.fn.input("Quick Chat: ")
      if input ~= "" then
        require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
      end
    end,
    { noremap = true, silent = true, desc = "CopilotChat - Quick chat about visual selection"}
)

-- Toggle CopilotChat pane
vim.keymap.set('n', '<leader>kk', ':CopilotChatToggle<cr>', { noremap = true, silent = true, desc = "CopilotChat - Toggle CopilotChat pane"})

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
