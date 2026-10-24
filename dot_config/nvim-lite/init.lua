vim.pack.add {
  "https://github.com/Mofiqul/dracula.nvim"
}

vim.cmd.colorscheme "dracula"

-- 行番号を絶対で表示
vim.opt.number = true
vim.relativenumber = true

vim.cmd.source(vim.fn.expand("~/.vimrc"))
