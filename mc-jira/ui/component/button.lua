local Node = require("mc-jira.ui.base.Node")
local Button = setmetatable({}, { __index = Node })
Button.__index = Button

function Button:new(props)
    local instance = Node.new(self, props)
    instance.label = props.label or "Button"
    instance.height = props.height or 1
    instance.width = props.width or string.len(instance.label)
    setmetatable(instance, self)
    return instance
end

function Button:draw(monitor)
    local x, y = self:globalPosition()
    if self.backgroundColor then
        monitor.setBackgroundColor(self.backgroundColor)
    end
    monitor.setCursorPos(x, y)
    monitor.write(self.label)
    monitor.setBackgroundColor(colors.black)
end

return Button