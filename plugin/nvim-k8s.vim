augroup NvimK8s
    autocmd!
    autocmd VimResized * :lua require("nvim-k8s.Window").onResize()
    autocmd VimEnter * :lua require("nvim-k8s").setupMapping()
augroup END
