local vim = vim
local Window = {}
Window.__index = Window

setmetatable(Window, {
    __call = function (class)
        return class.new()
    end
})

function Window.new()
    local self = setmetatable({}, Window)
    self.bgBuffer = nil
    self.bgWin = nil
    self.win = nil
    self.onClose = nil
    self.onCloseOrigin = nil

    self.widthPercentage = .8
    self.heightPercentage = .6
    return self
end

function RepeatText(text, times)
    local result = ""
    for _=1, times do
        result = result .. text
    end
    return result
end

function RepeatArray(arr, times)
    local result = {}
    for _=1, times do
        table.insert(result, arr)
    end
    return result
end

function Window:createBuffer(listed, scratch)
    return vim.api.nvim_create_buf(listed, scratch)
end

function Window:setSize(widthPercentage, heightPercentage)
    self.winWidth = widthPercentage
    self.winHeight = heightPercentage
end

function Window:calculateBackgroundSizes()
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    local bgWinHeight = math.ceil(height * self.heightPercentage - 4)
    local bgWinWidth = math.ceil(width * self.widthPercentage)

    local bgRow = math.ceil((height - bgWinHeight) / 2 - 1)
    local bgCol = math.ceil((width - bgWinWidth) / 2)

    return {
        bgWinHeight = bgWinHeight,
        bgWinWidth = bgWinWidth,
        bgRow = bgRow,
        bgCol = bgCol,
    }
end

function Window:calculateWindowSizes()
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    local winHeight = math.ceil(height * self.heightPercentage - 6)
    local winWidth = math.ceil(width * self.widthPercentage - 2)
    local row = math.ceil((height - winHeight) / 2 - 1)
    local col = math.ceil((width - winWidth) / 2)

    return {
        winHeight = winHeight,
        winWidth = winWidth,
        row = row,
        col = col
    }
end

function Window:decorateBuffer(buf, width, height)
    local top = "╭" .. RepeatText("─", width - 2) .. "╮"
    local mid = RepeatArray("│" .. RepeatText(" ", width - 2) .. "│", height - 2)
    local bot = "╰" .. RepeatText("─", width - 2) .. "╯"
    local lines = {}
    table.insert(lines, top)
    for i=1, #mid do
        table.insert(lines, mid[i])
    end
    table.insert(lines, bot)

    vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
end

function Window:openWindow(buf, widthPercentage, heightPercentage)
    if widthPercentage and heightPercentage then
        self:setSize(widthPercentage, heightPercentage)
    end

    self.bgBuffer = self.bgBuffer or self:createBuffer(false, true)

    self:decorateBuffer(
        self.bgBuffer,
        self:calculateBackgroundSizes()["bgWinWidth"],
        self:calculateBackgroundSizes()["bgWinHeight"]
    )

    self.bgWin = vim.api.nvim_open_win(
        self.bgBuffer,
        true,
        {
            relative='editor',
            row=self:calculateBackgroundSizes()["bgRow"],
            col=self:calculateBackgroundSizes()["bgCol"],
            width=self:calculateBackgroundSizes()["bgWinWidth"],
            height=self:calculateBackgroundSizes()["bgWinHeight"],
            style="minimal"
        }
    )

    --if self.win and vim.api.nvim_win_is_valid(self.win) then
    --    vim.api.nvim_win_set_buf(self.win, self.buffer)
    --else
        self.win = vim.api.nvim_open_win(
            buf,
            true,
            {
                relative='editor',
                row=self:calculateWindowSizes()["row"],
                col=self:calculateWindowSizes()["col"],
                width=self:calculateWindowSizes()["winWidth"],
                height=self:calculateWindowSizes()["winHeight"],
                style="minimal"
            }
        )
    --end

    vim.api.nvim_command(
        [[au BufWipeout <buffer> exe ':lua require("nvim-k8s.Window"):close()']]
    )
end

function Window:close()
    print("buff wiped out")
    if self.bgWin and vim.api.nvim_win_is_valid(self.bgWin) then
        vim.api.nvim_win_close(self.bgWin, {})
    end
    self.win = nil
    self.bgWin = nil
    self.bgBuffer = nil
    if self.onClose ~= nil then
        self.onClose(self.onCloseOrigin)
    end
end

function Window:hide()
    if self.win and vim.api.nvim_win_is_valid(self.win) then
        vim.api.nvim_win_hide(self.win)
    end
    if self.bgWin and vim.api.nvim_win_is_valid(self.bgWin) then
        vim.api.nvim_win_hide(self.bgWin)
    end
end

function Window:onClose(origin, fun)
    if fun ~= nil then
        self.onClose = fun
        self.onCloseOrigin = origin
    end
end

function Window:onResize()
    vim.api.nvim_win_set_config(self.bgBuf, {
        width = self:calculateBackgroundSizes()["bgWinWidth"],
        height = self:calculateBackgroundSizes()["bgWinHeight"],
        col = self:calculateBackgroundSizes()["bgCol"],
        row = self:calculateBackgroundSizes()["bgRow"],
    })

    self:decorateBuffer(
        self.bgBuf,
        self:calculateBackgroundSizes()["bgWinWidth"],
        self:calculateBackgroundSizes()["bgWinHeight"]
    )

    vim.api.nvim_win_set_config(self.win, {
        width = self:calculateWindowSizes()["winWidth"],
        height = self:calculateWindowSizes()["winHeight"],
        col = self:calculateWindowSizes()["col"],
        row = self:calculateWindowSizes()["row"],
    })
end

return Window()
