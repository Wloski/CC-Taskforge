local Node = require("taskforge/ui/base/node")
local Column = setmetatable({}, { __index = Node })
Column.__index = Column

function Column:new(props)
    local self = Node.new(self, props)
    self.children = props.children or {}
    self.__index = self
    return self
end

function Column:addChild(child)
    child.parent = self
    child.backgroundColor = child.backgroundColor or self.backgroundColor
    child.textColor = child.textColor or self.textColor
    child.centerTextEnabled = child.centerTextEnabled or self.centerTextEnabled

    if #self.children == 0 then
        child.x = 0
        child.y = 0 + self.padding
    else
        local prev = self.children[#self.children]
        child.x = 0
        child.y = prev.y + (prev.height or 1) + self.spaceBy
    end

    if child.y > (self.height - self.padding) then
        child.visible = false
    end
    table.insert(self.children, child)
end

function Column:Redraw()
    local y = 0
    for _, child in ipairs(self.children) do
        child.x = 0
        child.y = y
        x = x + (child.height or 1) + (self.padding or 0)
    end
end

return Column
