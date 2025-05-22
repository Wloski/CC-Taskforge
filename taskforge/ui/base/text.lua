local Node = require("taskforge/ui/base/node")
local Text = setmetatable({}, { __index = Node })
Text.__index = Text

function Text:new(props)
    local self = Node.new(self, props)
    self.content = props.content or ""
    -- TODO Set text padding
    self.width = props.width or string.len(self.content)
    self.height = props.height or 1
    self.wrapTextEnabled = props.wrapTextEnabled or false

    if self.wrapTextEnabled == true then
        self.height = #wrapText(props.content, props.width or self.width)
    end

    return self
end

function Text:draw(monitor)
    local x, y = self:globalPosition()
    if self.backgroundColor then
        monitor.setBackgroundColor(self.backgroundColor)
    end

    if self.textColor then
        monitor.setTextColor(self.textColor)
    end

    local wrappedText = wrapText(self.content, self.width)
    if #wrappedText == 1 and self.centerTextEnabled then
        self:centerText(self.content, x, y, self.width, monitor)
    elseif self.wrapTextEnabled == true then
        for _, line in ipairs(wrappedText) do
            monitor.setCursorPos(x, y)
            monitor.write(line)
            y = y + 1
        end
    else
        local formattedContent = self.content
        if (string.len(self.content) > self.width) then
            formattedContent = string.sub(self.content, 1, self.width)
        end
        monitor.setCursorPos(x, y)
        monitor.write(formattedContent)
    end

    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)
end

function wrapText(text, width)
    local wrapped = {}
    local line = ""
    for word in string.gmatch(text, "%S+") do
        if #line + #word + 1 > width then
            table.insert(wrapped, line)
            line = word
        else
            line = (line == "" and word) or (line .. " " .. word)
        end
    end
    if #line > 0 then
        table.insert(wrapped, line)
    end
    return wrapped
end

return Text
