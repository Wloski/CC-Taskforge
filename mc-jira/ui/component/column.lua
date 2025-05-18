local Node = require("mc-jira.ui.base.Node")
local Column = setmetatable({}, { __index = Node })
Column.__index = Column

function Column:new(props)
    local self = setmetatable({}, Column)
    self.children = props.children or {}
    self.x = props.x or 1
    self.y = props.y or 1
    self.padding = props.padding or 0
    self.width = (props.width) or 1
    self.height = props.height or 1
    self.backgroundColor = props.backgroundColor or nil
    self.__index = self
    return self
end

function Column:addChild(child)
    child.parent = self
    child.backgroundColor = self.backgroundColor or nil
    if #self.children == 0 then
        child.x = 0
        child.y = 0
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

return Column