-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.cmd([[
  autocmd FileType markdown setlocal conceallevel=0
]])
