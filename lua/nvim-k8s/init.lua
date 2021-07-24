local k8s = require("nvim-k8s.K8s")
local vim = vim

local function setupMapping()
    local keyMap = vim.g.vim_k8s_toggle_key_map or "π"

    vim.api.nvim_set_keymap(
        't',
        keyMap,
        '<C-\\><C-n><CMD>lua require("nvim-k8s.K8s"):toggle()<CR>',
        { noremap = true, silent = true }
    )

    vim.api.nvim_set_keymap(
        'n',
        keyMap,
        '<C-\\><C-n><CMD>lua require("nvim-k8s.K8s"):toggle()<CR>',
        { noremap = true, silent = true }
    )
end

return {
    setupMapping = setupMapping
}
