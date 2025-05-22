local Node = {}

function Node:new(props)
    props = props or {}
    local instance = {
        id = props.id or math.random(1000, 999999),
        x = props.x or 1,
        y = props.y or 1,
        position = props.position or "",
        width = props.width or 1,
        height = props.height or 1,
        parent = props.parent,
        onClick = props.onClick,
        padding = props.padding or 0,
        backgroundColor = props.backgroundColor or nil,
        textColor = props.textColor or colors.white,
        centerTextEnabled = props.centerTextEnabled or false,
        spaceBy = props.spaceBy or 0,
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
    local x, y = self.x or 0, self.y or 0
    local parent = self.parent
    while parent do
        x = x + (parent.x or 0)
        y = y + (parent.y or 0)
        parent = parent.parent
    end
    return x, y
end

function Node:draw(monitor)
    if self.backgroundColor then
        monitor.setBackgroundColor(self.backgroundColor)

        local x, y = self:globalPosition()
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
            child:onClick(child)
        end
        child:handleTouch(x, y)
    end
end

function Node:containsPoint(px, py)
    local gx, gy = self:globalPosition()
    return px >= gx and px < gx + self.width and py >= gy and py < gy + self.height
end

function Node:centerText(text, x, y, width, monitor)
    local startX = x + math.floor((width - string.len(text)) / 2)
    monitor.setCursorPos(startX, y)
    monitor.write(text)
end

return Node
