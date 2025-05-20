local Node = require("mc-jira/ui/base.node")
local Button = require("mc-jira/ui/base.button")
local Text = require("mc-jira/ui/base.text")
local Column = require("mc-jira/ui/base.column")
local Row = require("mc-jira/ui/base.row")
local colorList = require("mc-jira/utils/colors")
local NavigationBar = require("mc-jira/ui/component.navigation_bar")
local BaseScreen = require("mc-jira/ui/screens/base_screen")

local task = nil
local config = nil
local monitorWidth = 0
local monitorHeight = 0

local TicketScreen = BaseScreen:new()
function TicketScreen:build(_task, _config, _monitorWidth, _monitorHeight)
    task = _task
    config = _config
    monitorWidth = _monitorWidth
    monitorHeight = _monitorHeight
end

local function createRightTicketColumn(width)
    local ticketSideBar = Column:new({
        width = width,
        height = 20,
        padding = 1,
        backgroundColor = colors.gray
    })
    local taskStatusText = Text:new({
        content = "Status: " .. config.COLS[task.status],
        width = width,
        height = 1,
    })
    local taskPriorityText = Text:new({
        content = "Priority: " .. config.priority[task.priority],
        width = width,
        height = 1,
    })

    local startDateText = task.startDate or "None"
    local taskStartDateText = Text:new({
        content = "Start Date: " .. startDateText,
        width = width,
        height = 2,
        wrapTextEnabled = true,
    })



    ticketSideBar:addChild(taskStatusText)
    ticketSideBar:addChild(taskPriorityText)
    ticketSideBar:addChild(taskStartDateText)

    return ticketSideBar
end

local function createLeftTicketColumn(width)
    local ticketContent = Column:new({
        width = width,
        height = 20,
        padding = 1
    })

    local taskIdText = Text:new({
        content = "[" .. task.id .. "]",
        width = 20,
        height = 1,
    })

    local titleText = Text:new({
        content = task.text,
        width = 30,
        wrapTextEnabled = true
    })

    ticketContent:addChild(taskIdText)
    ticketContent:addChild(titleText)

    return ticketContent
end

function TicketScreen:create()
    local ticketScreenNode = Node:new({ width = monitorWidth, height = monitorHeight })

    local splitViewLayoutRow = Row:new({
        width = monitorWidth,
        height = 40,
    })

    local columnRatio = monitorWidth / 7
    splitViewLayoutRow:addChild(createLeftTicketColumn(columnRatio * 4))
    splitViewLayoutRow:addChild(createRightTicketColumn(columnRatio * 3))


    ticketScreenNode:addChild(NavigationBar.getNavBar())
    ticketScreenNode:addChild(splitViewLayoutRow)
    return ticketScreenNode
end

return TicketScreen
