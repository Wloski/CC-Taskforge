local Node = {}

function Node:new(props)
    props = props or {}
    local instance = {
        x = props.x or 1,
        y = props.y or 1,
        width = props.width or 1,
        height = props.height or 1,
        parent = props.parent,
        onClick = props.onClick,
        backgroundColor = props.backgroundColor or nil,
        children = {}
    }
    setmetatable(instance, self)
    self.__index = self
    return instance
end

function Node:addChild(child)
    if #self.children == 0 then
        child.x = self.x
        child.y = self.y
    else
        local prev = self.children[#self.children]
        child.x = self.x
        child.y = prev.y + (prev.height or 1)
    end
    child.parent = self
    table.insert(self.children, child)
end

function Node:globalPosition()
    local x, y = self.x, self.y
    local p = self.parent
    while p do
        x = x + p.x
        y = y + p.y
        p = p.parent
    end
    return x, y
end

function Node:draw(monitor)
    if self.backgroundColor then
        local x, y = self:globalPosition()
        monitor.setBackgroundColor(self.backgroundColor)
        for dy = 0, self.height - 1 do
            monitor.setCursorPos(x, y + dy)
            monitor.write(string.rep(" ", self.width))
        end
        monitor.setBackgroundColor(colors.black)
    end

    for _, child in ipairs(self.children) do
        if (child.visible ~= false) then
            child:draw(monitor)
        end
    end
end

function Node:handleTouch(x, y)
    for _, child in ipairs(self.children) do
        if child:containsPoint(x, y) and child.onClick then
            child:onClick()
        end
        child:handleTouch(x, y)
    end
end

function Node:containsPoint(px, py)
    local gx, gy = self:globalPosition()
    return px >= gx and px < gx + self.width and py >= gy and py < gy + self.height
end

return Node