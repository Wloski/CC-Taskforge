local Node = require("mc-jira.ui.base.Node")
local Row = setmetatable({}, { __index = Node })
Row.__index = Row

function Row:new(props)
    local props = props or {}
    local self = setmetatable({}, Row)
    self.children = props.children or {}
    self.x = props.x or 1
    self.y = props.y or 1
    self.width = props.width or 1
    self.height = props.height or 1
    self.padding = props.padding or 0
    self.backgroundColor = props.backgroundColor or nil
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