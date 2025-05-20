local Node = require("mc-jira.ui.base.node")
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
    child.backgroundColor = self.backgroundColor or nil
    if #self.children == 0 then
        child.x = 0
        child.y = 0 + self.padding
    else
        local prev = self.children[#self.children]
        child.x = 0
        child.y = prev.y + (prev.height or 1)
    end

    if child.y > self.height then
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
