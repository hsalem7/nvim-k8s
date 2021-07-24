# Vim-k8s
Vim-k8s is a [k9s](https://github.com/derailed/k9s) wrapper that will make your life easier when you are working on Kubernetes. You dont need to leave the nvim window anymore to control and debug your kubernetes environment.

# Installation

**Requirements**
[k9s](https://github.com/derailed/k9s) should be installed on your machine


**Using [vim-plug](https://github.com/junegunn/vim-plug)**

```vimscript
Plug 'hsalem7/nvim-k8s'
```

# Configuration
To change the keybinding that oppens the k8s window you can set the global variable as:
```vimscript
let g:vim_k8s_toggle_key_map = '<C-p>'
```
this will let the `Ctrl-P` toggle the k8s window
