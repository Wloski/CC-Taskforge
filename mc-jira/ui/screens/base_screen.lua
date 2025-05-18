local BaseScreen = {}

local function randomId()
    local t = {}
    for i = 1, 8 do
        t[i] = string.char(math.random(97, 122))
    end
    return table.concat(t)
end

function BaseScreen:new()
    local obj = setmetatable({}, { __index = self })
    obj.id = randomId()
    return obj
end

return BaseScreen