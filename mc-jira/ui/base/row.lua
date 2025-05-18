local Node = require("mc-jira.ui.base.node")
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
    child.backgroundColor = self.backgroundColor or nil
    if #self.children == 0 then
        child.x = 0
        child.y = 0
    else
        local prev = self.children[#self.children]
        child.x = prev.x + (prev.width or 1) + self.padding
        child.y = 0
    end
    table.insert(self.children, child)
end

return Row