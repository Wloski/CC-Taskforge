local Node = require("mc-jira/ui/base.node")
local Button = require("mc-jira/ui/base.button")
local Text = require("mc-jira/ui/base.text")
local Column = require("mc-jira/ui/base.column")
local Row = require("mc-jira/ui/base.row")
local colorList = require("mc-jira/utils/colors")
local NavigationBar = require("mc-jira/ui/component.navigation_bar")
local BaseScreen = require("mc-jira/ui/screens/base_screen")

local monitorWidth = 0
local monitorHeight = 0

local config = nil
local COLS = nil

local tasks = {}
local saveTasks = nil

local function getStatusColor(status)
    if status == 2 then
        return colors.blue
    elseif status == 3 then
        return colors.green
    else
        return colors.gray
    end
end

local SummaryScreenModule = BaseScreen:new()
function SummaryScreenModule:build(_tasks, _saveTasks, _config, _monitorWidth, _monitorHeight)
    tasks = _tasks
    saveTasks = _saveTasks
    config = _config
    COLS = config.COLS
    monitorWidth = _monitorWidth
    monitorHeight = _monitorHeight
end

function SummaryScreenModule:create(monitor)
    local summaryScreenNode = Node:new({ width = monitorWidth, height = monitorHeight })
    local titleRow = Row:new({
        width = monitorWidth - 2,
        height = 1,
        backgroundColor = colors.gray,
    })
    local title = Text:new({
        content = "MC-JIRA",
        color = colorList.white,
        width = monitorWidth - 2,
        height = 1,
        centerTextEnabled = true,
    })
    titleRow:addChild(title)

    local ticketDispalyWidth = monitorWidth - 2
    local ticketsColumn = Column:new({
        width = ticketDispalyWidth,
        height = 15,
    })
    for i = 1, #tasks do
        local task = tasks[i]
        local ticketRow = Row:new({
            width = ticketDispalyWidth,
            height = 1,
            padding = 1,
        })

        local taskName = Text:new({
            content = "[" .. task.id .. "]" .. task.text,
            width = 25,
            height = 1,
            onClick = function()
                local onTaskClicked = function()
                    os.queueEvent("toggle_view", "ticket", task)
                end
                NavigationBar.addNavigationBarItem(task.id, task.id, onTaskClicked)
                os.queueEvent("toggle_view", "ticket", task)
            end
        })

        local taskStatus = Text:new({
            content = COLS[task.status],
            width = 11,
            height = 1,
            textColor = getStatusColor(task.status),
            onClick = function()
                if (task.status == #COLS) then
                    task.status = 1
                else
                    task.status = task.status + 1
                end
                saveTasks(tasks)
            end
        })

        local onDeleteClicked = function()
            table.remove(tasks, i)
            NavigationBar.removeNavigationBarItem(task.id)
            saveTasks(tasks)
        end
        local deleteButton = Button:new({
            label = "Delete",
            width = 7,
            height = 1,
            textColor = colors.red,
            onClick = onDeleteClicked,
        })

        ticketRow:addChild(taskName)
        ticketRow:addChild(taskStatus)
        ticketRow:addChild(deleteButton)

        ticketsColumn:addChild(ticketRow)
    end

    summaryScreenNode:addChild(NavigationBar.getNavBar())
    summaryScreenNode:addChild(titleRow)
    summaryScreenNode:addChild(ticketsColumn)

    return summaryScreenNode
end

return SummaryScreenModule
