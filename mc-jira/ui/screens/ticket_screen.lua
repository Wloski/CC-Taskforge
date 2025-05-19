local Node = require("mc-jira/ui/base.node")
local Button = require("mc-jira/ui/base.button")
local Text = require("mc-jira/ui/base.text")
local Column = require("mc-jira/ui/base.column")
local Row = require("mc-jira/ui/base.row")
local colorList = require("mc-jira/utils/colors")
local NavigationBar = require("mc-jira/ui/component.navigation_bar")
local BaseScreen = require("mc-jira/ui/screens/base_screen")

local task = nil
local monitorWidth = 0
local monitorHeight = 0

local TicketScreen = BaseScreen:new()
function TicketScreen:build(_task, _monitorWidth, _monitorHeight)
    task = _task
    monitorWidth = _monitorWidth
    monitorHeight = _monitorHeight
end

function TicketScreen:create()
    local ticketScreenNode = Node:new({ width = monitorWidth, height = monitorHeight })
    local titleColumn = Column:new({
        width = monitorWidth -2,
        height = 1,
    })

    local id = Text:new({
        content = task.id,
        width = 20,
        height = 2,
    })

    local titleText = Text:new({
        content = task.text,
        width = 20,
        height = 2,
    })

    titleColumn:addChild(id)
    titleColumn:addChild(titleText)
    ticketScreenNode:addChild(NavigationBar)
    ticketScreenNode:addChild(titleColumn)
    return ticketScreenNode
end

return TicketScreen