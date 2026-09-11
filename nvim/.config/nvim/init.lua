-- Plugins
vim.pack.add({
	{ src = "https://github.com/chrisbra/Colorizer" },
	{ src = "https://github.com/sindrets/diffview.nvim" },
	{ src = "https://github.com/chentoast/marks.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
	{ src = "https://github.com/sainnhe/gruvbox-material" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/mrjones2014/smart-splits.nvim" },
	{ src = "https://github.com/pogyomo/submode.nvim" },
	{ src = "https://github.com/Wansmer/treesj" },
	{ src = "https://github.com/junegunn/vim-easy-align" },
	{ src = "https://github.com/kylechui/nvim-surround" },
	{ src = "https://github.com/machakann/vim-swap" },
	{ src = "https://github.com/tommcdo/vim-exchange" },
	{ src = "https://github.com/tpope/vim-abolish" },
	{ src = "https://github.com/tpope/vim-repeat" },
	{ src = "https://github.com/tpope/vim-speeddating" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/fidian/hexmode" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/folke/lazydev.nvim" },
	{ src = "https://github.com/bazelbuild/vim-bazel" },
	{ src = "https://github.com/google/vim-maktaba" },
	{ src = "https://github.com/justinmk/vim-gtfo" },
	{ src = "https://github.com/mawkler/demicolon.nvim" },
	{ src = "https://github.com/vim-scripts/DoxygenToolkit.vim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/brianhuster/live-preview.nvim" },
	{ src = "https://github.com/richardbizik/nvim-toc" },
	{ src = "https://github.com/zbirenbaum/copilot.lua" },
	{ src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim", version = "main" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/andythigpen/nvim-coverage" },
	{ src = "https://github.com/rebelot/heirline.nvim" },
	{ src = "https://github.com/linrongbin16/lsp-progress.nvim" },
	{ src = "https://github.com/folke/flash.nvim" },
	{ src = "https://github.com/hat0uma/csvview.nvim" },
	{ src = "https://github.com/pwntester/octo.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
})

-- Plugin setup

require("marks").setup({
	default_mappings = true,
	signs = true,
})

require("diffview").setup({
	use_icons = false,
  hooks = {
    diff_buf_win_enter = function(bufnr)
      -- open all folds by default
      vim.opt_local.foldlevel = 99
    end,
  }
})

local treesitter_group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })
local diagnostics_group = vim.api.nvim_create_augroup("UserDiagnostics", { clear = true })
local rust_group = vim.api.nvim_create_augroup("UserRust", { clear = true })
local python_group = vim.api.nvim_create_augroup("UserPython", { clear = true })
local quickfix_group = vim.api.nvim_create_augroup("UserQuickfix", { clear = true })
local selection_group = vim.api.nvim_create_augroup("UserSelection", { clear = true })
local format_group = vim.api.nvim_create_augroup("UserFormat", { clear = true })
local lsp_group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })

do
	local ts = require("nvim-treesitter")
	ts.setup({
		highlight = { enable = true, additional_vim_regex_highlighting = false },
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]f"] = "@function.outer",
					["]a"] = "@argument.outer",
					["]m"] = "@method.outer",
				},
				goto_previous_start = {
					["[f"] = "@function.outer",
					["[a"] = "@argument.outer",
					["[m"] = "@method.outer",
				},
			},
		},
		auto_install = true,
		sync_install = false,
	})

	ts.install({
		"c",
		"diff",
		"lua",
		"vim",
		"query",
		"markdown",
		"rust",
		"java",
		"elixir",
		"heex",
		"javascript",
		"typescript",
		"html",
		"yaml",
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = treesitter_group,
		pattern = {
			"c",
			"lua",
			"vim",
			"query",
			"markdown",
			"rust",
			"java",
			"elixir",
			"heex",
			"javascript",
			"typescript",
			"html",
			"yaml",
		},
		callback = function()
			vim.treesitter.start()
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	})
end

require("gitsigns").setup()

do
	local submode = require("submode")
	submode.create("WinResize", {
		mode = "n",
		enter = "<C-W>r",
		leave = { "<Esc>", "q", "<C-C>" },
		hook = {
			on_enter = function()
				vim.notify("Use { h, j, k, l } to resize the window")
			end,
			on_leave = function()
				vim.notify("")
			end,
		},
		default = function(register)
			register("h", require("smart-splits").resize_left, { desc = "Resize left" })
			register("j", require("smart-splits").resize_down, { desc = "Resize down" })
			register("k", require("smart-splits").resize_up, { desc = "Resize up" })
			register("l", require("smart-splits").resize_right, { desc = "Resize right" })
		end,
	})
end

require("treesj").setup({
	use_default_keymaps = false,
	dot_repeat = true,
})

require("nvim-surround").setup({})

require("fzf-lua").setup({
  fzf_bin = 'sk',
})

require("demicolon").setup({
	keymaps = {
		horizontal_motions = false,
		repeat_motions = false,
		disabled_keys = { "p", "I", "A", "i" },
	},
})

require("copilot").setup({
	server = {
		type = "binary",
	},
})

require("CopilotChat").setup({
	debug = true,
	model = "gpt-5.6-luna",
	sticky = { "#buffer", "#gitdiff" },
	window = {
		layout = "vertical",
		width = 0.3,
		height = 0.5,
		relative = "editor",
		border = "single",
		row = nil,
		col = nil,
		title = "Copilot Chat",
		footer = nil,
		zindex = 1,
	},
})

require("coverage").setup({
	auto_reload = false,
	lang = {
		rust = {
			coverage_command = '( LLVM_PROFILE_FILE="llvm_profile.profraw" cargo llvm-cov --package as-nimbus >/dev/null 2>&1 ) && grcov ${cwd} -s ${cwd} --binary-path ./target/debug/ -t coveralls --branch --ignore-not-existing --token NO_TOKEN',
			project_files_only = true,
			project_files = {
				"services/app/as-nimbus/src/**",
			},
		},
	},
})

require("lsp-progress").setup({
	format = function(messages)
		local sign = " ┃ £"
		if #messages > 0 then
			return sign .. "*"
		end
		local active_clients = vim.lsp.get_clients()
		if #active_clients > 0 then
			return sign
		end
		return ""
	end,
})

require("flash").setup({})

vim.keymap.set({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function()
	require("flash").remote()
end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function()
	require("flash").treesitter_search()
end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<C-S>", function()
	require("flash").toggle()
end, { desc = "Toggle Flash Search" })

require("nvim-toc").setup({
	toc_header = "Table of Contents",
})

-- maps leader to space
vim.g.mapleader = ' '
-- maps localleader to backspace
vim.g.maplocalleader = vim.api.nvim_replace_termcodes('<BS>', false, false, true)

vim.o.completeopt = "menu,menuone,popup,preview"

-- only source lsp for completions
vim.o.complete = "o"

-- improve lsp diag window performance
vim.o.updatetime = 250

-- diagnostic display settings
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- Setup language servers.
vim.lsp.log.set_level("OFF")
vim.api.nvim_create_autocmd("CursorHold", {
	group = diagnostics_group,
	callback = function()
		local opts = {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "rounded",
			source = "always",
			prefix = " ",
		}
		vim.diagnostic.open_float(nil, opts)
	end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- rust lsp
vim.lsp.config("rust_analyzer", {
	-- Server-specific settings. See `:help lspconfig-setup`
	on_attach = function(client, bufnr)
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end,
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
				loadOutDirsFromCheck = true,
				runBuildScripts = true,
				-- use a separate dir so Cargo.lock isn't held. duplicates artifacts
				targetDir = true,
			},
			diagnostics = {
				enable = true,
			},
			checkOnSave = true,
			-- Add clippy lints for Rust.
			check = {
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
vim.lsp.enable({ "rust_analyzer" })
-- markdown lsp
vim.lsp.config("marksman", {})
vim.lsp.enable({ "marksman" })
-- python lsp
vim.lsp.config("pyright", {})
vim.lsp.enable({ "pyright" })
-- clang lsp
vim.lsp.config("clangd", {
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
vim.lsp.enable({ "clangd" })
-- protocol buffers lsp
vim.lsp.config("protols", {})
vim.lsp.enable({ "protols" })
-- grammar lsp
vim.lsp.config("harper_ls", {
	settings = {
		["harper-ls"] = {
			linters = {
				SentenceCapitalization = false,
				SpellCheck = false,
				ToDoHyphen = false,
			},
		},
	},
})

-- lazydev.nvim setup for type checking, autocomplete, etc.
require("lazydev").setup({
	library = { "nvim-dap-ui" },
})

local dap = require("dap")
require("dapui").setup()

-- run dapui on dap events
local dapui = require("dapui")
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
dap.adapters.gdb = {
	type = "executable",
	command = "gdb",
	args = { "-i", "dap" },
}

dap.configurations.c = {
	{
		name = "Launch",
		type = "gdb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
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
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopAtBeginningOfMainSubprogram = false,
	},
}

-- needed for newer versions of rustfmt(?)
vim.g.rustfmt_emit_files = 1

vim.api.nvim_create_autocmd("FileType", {
	group = rust_group,
	pattern = "rust",
	callback = function(args)
		vim.keymap.set("n", "<leader>i", "<cmd>RustFmt<CR>", {
			buffer = args.buf,
			noremap = true,
			silent = true,
			desc = "Run rustfmt on current file",
		})

		vim.keymap.set("n", "<leader>mm", "<cmd>silent !cargo run<CR>", {
			buffer = args.buf,
			noremap = true,
			silent = true,
			desc = "Cargo run",
		})

		vim.api.nvim_buf_call(args.buf, function()
			vim.cmd("compiler cargo")
		end)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = python_group,
	pattern = "python",
	callback = function()
		vim.opt_local.formatprg = "black --quiet -"
	end,
})

-- Set undo/backup/swap files to directory in home
vim.o.undodir = vim.fn.expand("$HOME/.local/state/nvim/.undo//")
vim.o.backupdir = vim.fn.expand("$HOME/.local/state/nvim/.backup//")
vim.o.directory = vim.fn.expand("$HOME/.local/state/nvim/.swp//")

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

-- Themes
vim.opt.background = "dark"
vim.g.gruvbox_material_foreground = "original"
vim.g.gruvbox_material_background = "hard"
vim.cmd("colorscheme gruvbox-material")

vim.filetype.add({
	filename = {
		SConstruct = "python",
		SConscript = "python",
		[".clang-format"] = "yaml",
		[".clang-tidy"] = "yaml",
	},
	pattern = {
		[".*%.service"] = "gitconfig",
	},
})

-- heirline
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local Ruler = {
	-- %l = current line number
	-- %c = column number
	-- %P = percentage through file of displayed window
	provider = " %l,%c %P",
}

local FileLastModified = {
	provider = function()
		local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
		return (ftime > 0) and os.date("%m/%d/%y %H:%M", ftime)
	end,
}

local Git = {
	condition = conditions.is_git_repo,

	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
	end,

	{ -- git branch name
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
		if filename == "" then
			return "[No Name]"
		end
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
		return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	end,
}

local FileNameWithFlags = utils.insert(
	FileNameBlock,
	utils.insert(FileName), -- a new table where FileName is a child of FileNameModifier
	FileFlags,
	{
		provider = "%<",
	} -- this means that the statusline is cut here when there's not enough space
)

local LspProgress = {
	provider = function()
		return require("lsp-progress").progress()
	end,
	update = {
		"User",
		pattern = "LspProgressStatusUpdated",
		callback = vim.schedule_wrap(function()
			vim.cmd("redrawstatus")
		end),
	},
}

local StatusLine = {
	FileNameWithFlags,
	{ provider = " ┃ " },
	WorkingDir,
	Git,
	LspProgress,
	{ provider = "%=" }, -- align right
	Ruler,
	{ provider = " ┃ " },
	FileLastModified,
}

require("heirline").setup({
	statusline = StatusLine,
})

require"octo".setup {
  picker = "fzf-lua",
  enable_builtin = true,
  mappings = {
    runs = {
      open_in_browser = { lhs = "<localleader>b", desc = "open workflow run in browser" },
      rerun = { lhs = "<localleader>o", desc = "rerun workflow" },
    }
  }
}
vim.treesitter.language.register("markdown", "octo")

require("render-markdown").setup({
  file_types = { "octo" },
})

-- auto open quickfix when populated
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = quickfix_group,
	pattern = "*",
	command = "copen",
})

-- Enable special doxygen highlighting
vim.g.load_doxygen_syntax = 1

-- Ignore compiled files
vim.o.wildignore = "*.o,*~,*.pyc,*.d"

-- Height of the command bar
vim.o.cmdheight = 2

-- How many tenths of a second to blink when matching brackets
vim.o.mat = 2

-- Line numbers
vim.wo.number = true

-- Mouse setup
vim.o.mouse = "a"

-- Cursor line/column highlighting
vim.wo.cursorline = true
vim.wo.cursorcolumn = true

-- Show 10 lines below/above cursor at all times
vim.o.scrolloff = 10

-- Use ripgrep as the search tool
vim.o.grepprg = "rg --vimgrep --smart-case"
vim.o.grepformat = "%f:%l:%c:%m"

-- Use smartcase for inc searching
vim.o.ignorecase = true
vim.o.smartcase = true

-- use patience diff algorithm
vim.o.diffopt = "internal,algorithm:patience,indent-heuristic"

-- maximum 2 signs in signcolumn
vim.opt.signcolumn = "auto:2"

-- Mouse-selected text copies to primary selection clipboard
vim.api.nvim_create_autocmd("CursorMoved", {
	group = selection_group,
	desc = "Keep * synced with selection",
	callback = function()
		local mode = vim.fn.mode(false)
		if mode == "v" or mode == "V" or mode == "^V" then
			vim.cmd([[silent norm "*ygv]])
		end
	end,
})

-- set external format tools based on filetype
vim.api.nvim_create_autocmd("FileType", {
	group = format_group,
	pattern = { "c", "cpp" },
	callback = function()
		vim.opt_local.formatprg = "clang-format --assume-filename=%"
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	group = format_group,
	pattern = { "sh", "bash" },
	callback = function()
		vim.opt_local.makeprg = "shellcheck -f gcc %"
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	group = format_group,
	pattern = "lua",
	callback = function()
		vim.opt_local.formatprg = "stylua -"
	end,
})

-- run formatprg, retab, and trim whitespace on entire buffer

local function autoformat_current_file()
	local save = vim.fn.winsaveview()
	vim.cmd('execute "keepjumps normal! gggqG"')
	vim.fn.winrestview(save)
end

-- automatically resize windows when the host window size changes (e.g. tmux pane resize)
local wr_group = vim.api.nvim_create_augroup("WinResize", { clear = true })
vim.api.nvim_create_autocmd("VimResized", {
	group = wr_group,
	pattern = "*",
	command = "wincmd =",
	desc = "Automatically resize windows when the host window size changes.",
})
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

vim.keymap.set("n", "<leader>q", toggle_quickfix, { desc = "Toggle Quickfix Window" })

vim.keymap.set("n", "<leader>p", '"_ciw<C-R>"<esc>', { desc = "Replace word with clipboard, preserving clipboard" })

vim.keymap.set('n', ']c', function()
  if vim.wo.diff then
    vim.cmd.normal({']c', bang = true})
  else
    require("gitsigns").nav_hunk('next')
  end
end, { desc = "Next Git hunk" })

vim.keymap.set('n', '[c', function()
  if vim.wo.diff then
    vim.cmd.normal({'[c', bang = true})
  else
    require("gitsigns").nav_hunk('prev')
  end
end, { desc = "Previous Git hunk" })

vim.keymap.set({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Git stage hunk" })
vim.keymap.set({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Git reset hunk" })
vim.keymap.set("n", "<leader>hS", ":Gitsigns stage_buffer<CR>", { desc = "Git stage buffer" })
vim.keymap.set("n", "<leader>hu", ":Gitsigns undo_stage_hunk<CR>", { desc = "Git undo stage hunk" })
vim.keymap.set("n", "<leader>hR", ":Gitsigns reset_buffer<CR>", { desc = "Git reset buffer" })
vim.keymap.set("n", "<leader>hp", ":Gitsigns preview_hunk<CR>", { desc = "Git preview hunk" })
vim.keymap.set("n", "<leader>hb", ":Gitsigns blame_line<CR>", { desc = "Git blame line" })
vim.keymap.set("n", "<leader>hd", ":Gitsigns diffthis<CR>", { desc = "Git show buffer diff" })
vim.keymap.set("n", "<leader>td", ":Gitsigns toggle_deleted<CR>", { desc = "Git toggle deleted lines" })
vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git telect hunk" })

vim.keymap.set("n", "<leader>vv", ":source $MYVIMRC<CR>", { desc = "Reload Neovim config" })

vim.keymap.set("n", "<leader>e", ":edit<CR>", { desc = "Reload current buffer" })

vim.keymap.set("n", "<leader>c", ":tabnew<CR>", { desc = "Create tab" })

vim.keymap.set("n", "<C-N>", ":cn<CR>", { desc = "Next quickfix item" })
vim.keymap.set("n", "<C-P>", ":cp<CR>", { desc = "Previous quickfix item" })

vim.keymap.set("n", "glt", function()
	require("coverage").jump_next("uncovered")
end, { desc = "Next uncovered coverage" })
vim.keymap.set("n", "glT", function()
	require("coverage").jump_prev("uncovered")
end, { desc = "Prev uncovered coverage" })

vim.keymap.set("n", "j", "gj", { desc = "Move down by display line" })
vim.keymap.set("n", "k", "gk", { desc = "Move up by display line" })

vim.keymap.set("n", "<leader>1", "1gt", { desc = "Go to tab 1" })
vim.keymap.set("n", "<leader>2", "2gt", { desc = "Go to tab 2" })
vim.keymap.set("n", "<leader>3", "3gt", { desc = "Go to tab 3" })
vim.keymap.set("n", "<leader>4", "4gt", { desc = "Go to tab 4" })
vim.keymap.set("n", "<leader>5", "5gt", { desc = "Go to tab 5" })
vim.keymap.set("n", "<leader>6", "6gt", { desc = "Go to tab 6" })
vim.keymap.set("n", "<leader>7", "7gt", { desc = "Go to tab 7" })
vim.keymap.set("n", "<leader>8", "8gt", { desc = "Go to tab 8" })
vim.keymap.set("n", "<leader>9", "9gt", { desc = "Go to tab 9" })
vim.keymap.set("n", "<leader>0", ":tablast<CR>", { desc = "Go to last tab" })

vim.keymap.set("n", "'", "`", { desc = "Jump to mark" })

vim.keymap.set("v", "<leader>ds", ":'<,'>sort u<CR>", { desc = "Sort and deduplicate selection" })

vim.keymap.set("n", "<leader>do", ":DiffviewOpen<CR>", { desc = "Open Diffview" })
vim.keymap.set("n", "<leader>dx", ":DiffviewClose<CR>", { desc = "Close Diffview" })
vim.keymap.set("n", "<leader>db", ":DiffviewOpen main... --imply-local --untracked-files=all<CR>", { desc = "Diff against main" })
vim.keymap.set("n", "<leader>dr", ":DiffviewRefresh<CR>", { desc = "Refresh Diffview" })

vim.keymap.set("n", "<leader>yf", ':let @+=expand("%:t")<CR>', { desc = "Yank filename" })
vim.keymap.set("n", "<leader>yr", ':let @+=expand("%:p:.")<CR>', { desc = "Yank relative file path" })
vim.keymap.set("n", "<leader>ya", ':let @+=expand("%:p")<CR>', { desc = "Yank absolute file path" })
vim.keymap.set("n", "<leader>Y", ':echo expand("%:p:.")<CR>', { desc = "Show relative file path" })

vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Show Git blame" })
vim.keymap.set("n", "<leader>gs", ":Git <CR>", { desc = "Show Git status" })
vim.keymap.set("n", "<leader>gp", ":Gpush<CR>", { desc = "Push Git changes" })
vim.keymap.set("n", "<leader>gc", ":Gcommit -v<CR>", { desc = "Commit Git changes" })
vim.keymap.set("n", "<leader>gw", ":Gwrite<CR>", { desc = "Stage current file" })
vim.keymap.set("n", "<leader>gd", ":Gvdiff<CR>", { desc = "Diff current file against HEAD" })
vim.keymap.set("n", "<leader>gh", ":Gclog<CR>", { desc = "Show file commit history" })

vim.keymap.set("n", "<leader>H", ":Hexmode<CR>", { desc = "Toggle Hexmode" })

vim.keymap.set("n", "<leader>r", ":%s/<C-R><C-W>//gc<Left><Left><Left>", { silent = true, desc = "Replace current word" })

vim.keymap.set("i", "<C-D>", "<del>", { silent = true, desc = "Delete character" })

vim.keymap.set("c", "<C-J>", "<down>", { silent = true, desc = "Next command history item" })
vim.keymap.set("c", "<C-K>", "<up>", { silent = true, desc = "Previous command history item" })

vim.keymap.set("n", "<leader>ww", ":tabe ~/wiki/index.md<CR>:lcd %:p:h<CR>", { silent = true, desc = "Open wiki index" })

vim.keymap.set("n", "<leader>wc", ":lcd %:p:h<CR>", { silent = true, desc = "Set window directory to file" })

vim.keymap.set("x", "ga", "<Plug>(EasyAlign)", { desc = "EasyAlign selection" })
vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", { desc = "EasyAlign motion" })

vim.keymap.set("n", "<leader>R", ":cdo %s/<C-R><C-W>//gc<Left><Left><Left>", { desc = "Replace current word in quickfix" })

vim.keymap.set("n", "<leader>o", ":FzfLua files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>ao", ":FzfLua buffers<CR>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>as", ":FzfLua lines<CR>", { desc = "Search all buffer lines" })
vim.keymap.set("n", "<leader>aa", ":FzfLua blines<CR>", { desc = "Search current buffer lines" })
vim.keymap.set("n", "<leader>ag", ":FzfLua git_files<CR>", { desc = "Find Git files" })
vim.keymap.set("n", "<leader>at", ":FzfLua treesitter<CR>", { desc = "Find Treesitter symbols" })
vim.keymap.set("n", "<leader>af", ":FzfLua grep<CR>", { desc = "Search with grep" })
vim.keymap.set("n", "<leader>al", ":FzfLua live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>ak", ":FzfLua keymaps<CR>", { desc = "Show keymaps" })

vim.keymap.set("n", "<leader><esc>", ":redraw!<CR>:noh<CR>", { silent = true, desc = "Redraw and clear search highlight" })
vim.keymap.set("n", "<leader>/", ':silent! grep ""<Left>', { silent = true, desc = "Search with grep" })
vim.keymap.set("n", "<leader>?", ':GrepAll ""<Left>', { silent = true, desc = "Search all files" })
vim.keymap.set("n", "<leader>f", ':silent! grep "<C-R><C-W>"<CR>', { silent = true, desc = "Grep current word" })
vim.keymap.set("n", "<leader>F", ':GrepAll "<C-R><C-W>"<CR>', { silent = true, desc = "Search all files for current word" })
vim.keymap.set("n", "<leader>mr", ":make<Up><CR>", { silent = true, desc = "Run last make command" })
vim.keymap.set("n", "<leader>mm", ":silent make!<CR>:redraw!<CR>", { silent = true, desc = "Run make" })
vim.keymap.set("n", "<leader>mc", ":make clean<CR>", { silent = true, desc = "Run make clean" })
vim.keymap.set("n", "<leader>mt", ":make test<CR>", { silent = true, desc = "Run make test" })

-- grep and include all hidden/ignored files
vim.api.nvim_create_user_command("GrepAll", function(opts)
	vim.cmd("silent grep! " .. table.concat(opts.fargs, " ") .. " -uu")
	vim.cmd("redraw!")
end, { nargs = "+" })

-- debugging
-- TODO: figure out alternate prefix than ,
-- vim.keymap.set("n", ",c", function()
-- 	require("dap").continue()
-- end)
-- vim.keymap.set("n", ",o", function()
-- 	require("dap").step_over()
-- end)
-- vim.keymap.set("n", ",s", function()
-- 	require("dap").step_into()
-- end)
-- vim.keymap.set("n", ",S", function()
-- 	require("dap").step_out()
-- end)
-- vim.keymap.set("n", ",b", function()
-- 	require("dap").toggle_breakpoint()
-- end)
-- vim.keymap.set("n", ",r", function()
-- 	require("dap").repl.open()
-- end)
-- vim.keymap.set("n", ",dl", function()
-- 	require("dap").run_last()
-- end)
-- vim.keymap.set({ "n", "v" }, ",h", function()
-- 	require("dap.ui.widgets").hover()
-- end)
-- vim.keymap.set({ "n", "v" }, ",p", function()
-- 	require("dap.ui.widgets").preview()
-- end)

vim.keymap.set("n", "<leader>j", require("treesj").toggle, { desc = "Toggle split/join lines" })

vim.keymap.set("n", "<leader>i", autoformat_current_file, { desc = "Format current buffer" })

vim.keymap.set("n", "<leader>vu", function()
	vim.pack.update(nil, { force = true })
end, { desc = "Update plugins" })

vim.keymap.set("t", "<esc>", "<C-\\><C-N>", { desc = "Exit terminal mode" })

vim.keymap.set({ "n", "v", "i" }, "<C-X><C-F>", function()
	require("fzf-lua").complete_path()
end, { silent = true, desc = "Fuzzy complete path" })

vim.keymap.set("n", "<leader>ll", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { noremap = true, silent = true, desc = "Toggle vim diagnostics" })

vim.keymap.set(
	"v",
	"<leader>kf",
	":'<,'>CopilotChatFix <CR>",
	{ noremap = true, silent = true, desc = "CopilotChat - Fix visual selection" }
)

vim.keymap.set(
	"v",
	"<leader>ke",
	":'<,'>CopilotChatExplain <CR>",
	{ noremap = true, silent = true, desc = "CopilotChat - Explain visual selection" }
)

vim.keymap.set(
	"v",
	"<leader>kr",
	":'<,'>CopilotChatReview <CR>",
	{ noremap = true, silent = true, desc = "CopilotChat - Review visual selection" }
)

vim.keymap.set(
	"v",
	"<leader>kd",
	":'<,'>CopilotChatDocs <CR>",
	{ noremap = true, silent = true, desc = "CopilotChat - Document visual selection" }
)


-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_group,
	callback = function(ev)
		local client_id = ev.data and ev.data.client_id
		local client = client_id and vim.lsp.get_client_by_id(client_id) or nil
		local opts = { buffer = ev.buf }
		if client_id then
			vim.lsp.completion.enable(true, client_id, ev.buf, {
				-- auto-show menu as you type
				autotrigger = true,
			})
		end

		-- See `:help vim.lsp.*` for documentation on any of the below functions
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
		vim.keymap.set("n", "<C-K>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Show signature help" }))

		if client and client.name == "clangd" then
			vim.keymap.set("n", "<leader>lh", ":ClangdSwitchSourceHeader<CR>", vim.tbl_extend("force", opts, { desc = "Switch source/header" }))
		end
	end,
})

vim.keymap.set("n", "<leader>kc", function()
	local input = vim.fn.input("Quick Chat: ")
	if input ~= "" then
		require("CopilotChat").ask(input, {
			selection = require("CopilotChat.select").buffer,
		})
	end
end, { desc = "CopilotChat - Quick chat" })

vim.keymap.set("v", "<leader>kv", function()
	local input = vim.fn.input("Quick Chat: ")
	if input ~= "" then
		require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
	end
end, { noremap = true, silent = true, desc = "CopilotChat - Quick chat about visual selection" })

vim.keymap.set(
	"n",
	"<leader>kk",
	":CopilotChatToggle<CR>",
	{ noremap = true, silent = true, desc = "CopilotChat - Toggle CopilotChat pane" }
)

vim.keymap.set("n", "<leader>tg", ":Coverage<CR>", { desc = "Show code coverage" })
vim.keymap.set("n", "<leader>tc", ":CoverageToggle<CR>", { desc = "Toggle code coverage" })

vim.keymap.set({ "x", "o" }, "aF", function()
	vim.cmd("normal! [m")
	require("nvim-treesitter.textobjects.select").select_textobject("@function.outer", "textobjects")
end, { desc = "Select previous function.outer" })

vim.keymap.set({ "x", "o" }, "iF", function()
	vim.cmd("normal! [m")
	require("nvim-treesitter.textobjects.select").select_textobject("@function.inner", "textobjects")
end, { desc = "Select previous function.inner" })

vim.keymap.set({ "n", "x", "o" }, ";", require("demicolon.repeat_jump").next, { desc = "Repeat jump forward" })
vim.keymap.set({ "n", "x", "o" }, ",", require("demicolon.repeat_jump").prev, { desc = "Repeat jump backward" })

vim.keymap.set("n", "<leader>S", ":setlocal spell!<CR>", { desc = "Toggle spellcheck" })
