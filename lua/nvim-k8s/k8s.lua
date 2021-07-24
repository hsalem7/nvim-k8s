local Window = require("nvim-k8s.Window")
local vim = vim
local cmd = vim.api.nvim_command
local K8s = {}
K8s.__index = K8s

setmetatable(K8s, {
    __call = function (cls)
        return cls.new()
    end
})

function K8s.new()
    local self = setmetatable({}, K8s)
    self.buffer = nil
    self.width = .8
    self.height = .5
    self.openned = false
    return self
end

function K8s:exec()
    local osName = vim.fn.system('uname -s')
    print(vim.fn.has("win64"), vim.fn.has("win32"))

    if vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
        osName = 'Win'
    end

    if  osName == 'Darwin' then
        vim.fn.termopen('./bin/mac/k9s')
    elseif osName == 'Win' then
        vim.fn.termopen('./bin/win/k9s.exe')
    elseif osName == 'Linux' then
        vim.fn.termopen('./bin/linux/k9s')
    else
        vim.fn.termopen('k9s')
    end
end

function K8s:createBuffer(listed, scratch)
    return vim.api.nvim_create_buf(listed, scratch)
end

local function close(s)
    s.buffer = nil
    s.openned = false
end

function K8s:open()
    local bufCreated = false

    if not self.buffer then
        self.buffer = K8s:createBuffer(false, true)
        bufCreated = true
    end

    Window:openWindow(self.buffer, self.width, self.height)

    if bufCreated then
        self:exec()
    end

     Window:onClose(self, close)

    cmd("startinsert")

    self.openned = true
end

function K8s:toggle()
    if self.openned == true then
        self:hide()
    else
        self:open()
    end
end

function K8s:hide()
    Window:hide()
    self.openned = false
end

return K8s()
