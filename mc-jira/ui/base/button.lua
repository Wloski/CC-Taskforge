local Node = require("mc-jira.ui.base.node")
local Button = setmetatable({}, { __index = Node })
Button.__index = Button

function Button:new(props)
    local instance = Node.new(self, props)
    instance.label = props.label or "Button"
    instance.width = props.width or string.len(instance.label)

    setmetatable(instance, self)
    return instance
end

function Button:draw(monitor)
    local x, y = self:globalPosition()
    if self.backgroundColor then
        monitor.setBackgroundColor(self.backgroundColor)
    end
    if self.textColor then
        monitor.setTextColor(self.textColor)
    end
    if self.centerTextEnabled then
        self:centerText(self.label, x, y, self.width, monitor)
    end
    monitor.setCursorPos(x, y)
    monitor.write(self.label)
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)
end

return Button