local Node = require("taskforge/ui/base.node")
local Button = require("taskforge/ui/base.button")
local Text = require("taskforge/ui/base.text")
local Column = require("taskforge/ui/base.column")
local Row = require("taskforge/ui/base.row")
local colorList = require("taskforge/utils/colors")
local NavigationBar = require("taskforge/ui/component.navigation_bar")
local BaseScreen = require("taskforge/ui/screens/base_screen")

local task = nil
local tasks = nil
local saveTask = nil
local deleteTaskById = nil
local getStatusColor = nil
local config = nil
local monitorWidth = 0
local monitorHeight = 0

local TicketScreen = BaseScreen:new()
function TicketScreen:build(
    _task,
    _saveTask,
    _deleteTaskById,
    _getStatusColor,
    _config,
    _monitorWidth,
    _monitorHeight
)
    task = _task
    saveTask = _saveTask
    deleteTaskById = _deleteTaskById
    getStatusColor = _getStatusColor
    config = _config
    monitorWidth = _monitorWidth
    monitorHeight = _monitorHeight
end

local function createRightTicketColumn(width)
    local ticketSideBar = Column:new({
        width = width,
        height = 20,
        padding = 1,
        spaceBy = 1,
        backgroundColor = colors.gray,
    })

    local statusRow = Row:new({
        width = width,
        height = 1,
        backgroundColor = colors.gray
    })
    local titleStatusText = Text:new({
        content = "Status:",
        height = 1,
    })
    local valueStatusText = Text:new({
        content = config.COLS[task.status],
        backgroundColor = getStatusColor(task.status),
        height = 1,
    })

    statusRow:addChild(titleStatusText)
    statusRow:addChild(valueStatusText)


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



    ticketSideBar:addChild(statusRow)
    ticketSideBar:addChild(taskPriorityText)
    ticketSideBar:addChild(taskStartDateText)

    return ticketSideBar
end

local function createLeftTicketColumn(width)
    local ticketContent = Column:new({
        width = width,
        height = 20,
        padding = 1,
        spaceBy = 1,
    })

    local taskIdText = Text:new({
        content = "[" .. task.id .. "]",
        width = width,
        height = 1,
    })

    local titleText = Text:new({
        content = task.text,
        width = width,
        wrapTextEnabled = true,
        onClick = function(it)
            local x, y = it:globalPosition()
            term.setCursorPos(x, y)
            task.text = read(nil, nil, nil, task.text)
            saveTask(task)
        end
    })

    local descriptionColor = colors.white
    if (task.description == nil) then
        descriptionColor = colors.gray
    end
    print(task.description)
    local descriptionText = Text:new({
        content = task.description or "Insert description",
        width = width,
        wrapTextEnabled = true,
        textColor = descriptionColor,
        onClick = function(it)
            local x, y = it:globalPosition()
            term.setCursorPos(x, y)
            task.description = read(nil, nil, nil, task.description)
            saveTask(task)
        end
    })

    ticketContent:addChild(taskIdText)
    ticketContent:addChild(titleText)
    ticketContent:addChild(descriptionText)

    return ticketContent
end

function TicketScreen:create()
    local ticketScreenNode = Node:new({ width = monitorWidth, height = monitorHeight })

    local splitViewLayoutRow = Row:new({
        width = monitorWidth,
        height = 15,
    })

    local columnRatio = ((monitorWidth - 2) / 7)
    splitViewLayoutRow:addChild(createLeftTicketColumn(columnRatio * 4))
    splitViewLayoutRow:addChild(createRightTicketColumn(columnRatio * 3))

    local bottomBar = Row:new({
        width = monitorWidth,
        height = 1,
    })
    local deleteButton = Button:new({
        label = "Delete",
        width = 7,
        height = 1,
        textColor = colors.red,
        onClick = function()
            deleteTaskById(task.id)
            NavigationBar.removeNavigationBarItem(task.id)
            os.queueEvent("toggle_view", "summary")
        end
    })
    bottomBar:addChild(deleteButton)

    ticketScreenNode:addChild(NavigationBar.getNavBar())
    ticketScreenNode:addChild(splitViewLayoutRow)
    ticketScreenNode:addChild(bottomBar)
    return ticketScreenNode
end

return TicketScreen
