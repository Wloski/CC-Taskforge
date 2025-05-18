local Node = require("mc-jira.ui.base.Node")
local Text = setmetatable({}, { __index = Node })
Text.__index = Text

function Text:new(props)
    local instance = Node.new(self, props)
    instance.content = props.content or ""
    -- TODO Set text padding
    instance.width = props.width or string.len(props.content)
    instance.height = #wrapText(props.content, props.width or instance.width)
    instance.centerText = props.centerText or false
    instance.textColor = props.textColor or nil
    instance.backgroundColor = props.backgroundColor or nil
    setmetatable(instance, self)
    return instance
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
    if #wrappedText == 1 and self.centerText then
        centerText(self.content, x, y, self.width, monitor)
    else 
        for _, line in ipairs(wrappedText) do
            monitor.setCursorPos(x, y)
            monitor.write(line)
            y = y + 1
        end
    end

    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)
end

function centerText(text, x, y, width, monitor)
    local startX = x + math.floor((width - string.len(text)) / 2)
    monitor.setCursorPos(startX, y)
    monitor.write(text)
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