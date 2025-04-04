vim.g.rustfmt_command = 'rustfmt --edition 2021'

vim.keymap.set('n', '<leader>i', ":RustFmt<cr>", { noremap = true, silent = true, desc = "Run rustfmt on current file" })
vim.keymap.set('n', '<leader>mm', ':silent !cargo run<cr>', { noremap = true, silent = true, desc = "Cargo run"})
vim.cmd('compiler cargo')
