local Node = require("taskforge/ui/base/node")
local Row = setmetatable({}, { __index = Node })
Row.__index = Row

function Row:new(props)
    local self = Node.new(self, props)
    self.children = props.children or {}
    self.__index = self
    return self
end

function Row:addChild(child)
    child.parent = self
    child.backgroundColor = child.backgroundColor or self.backgroundColor
    child.textColor = child.textColor or self.textColor
    child.centerTextEnabled = child.centerTextEnabled or self.centerTextEnabled

    if #self.children == 0 then
        child.x = 0
        child.y = 0
    else
        local prev = self.children[#self.children]
        child.x = prev.x + (prev.width or 1) + self.spaceBy
        child.y = 0
    end
    table.insert(self.children, child)
end

function Row:Redraw()
    local x = 0
    for _, child in ipairs(self.children) do
        child.x = x
        child.y = 0
        x = x + (child.width or 1) + (self.padding or 0)
    end
end

return Row
