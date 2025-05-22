local Node = require("taskforge/ui/base.node")
local Button = require("taskforge/ui/base.button")
local Text = require("taskforge/ui/base.text")
local Column = require("taskforge/ui/base.column")
local Row = require("taskforge/ui/base.row")
local colorList = require("taskforge/utils/colors")
local NavigationBar = require("taskforge/ui/component.navigation_bar")
local BaseScreen = require("taskforge/ui/screens/base_screen")

local monitorWidth = 0
local monitorHeight = 0

local config = nil
local COLS = nil

local tasks = {}
local saveTasks = nil
local getStatusColor = nil

local SummaryScreenModule = BaseScreen:new()
function SummaryScreenModule:build(_tasks, _saveTasks, _getStatusColor, _config, _monitorWidth, _monitorHeight)
    tasks = _tasks
    saveTasks = _saveTasks
    getStatusColor = _getStatusColor
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
        content = "Summary",
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
            spaceBy = 1,
        })

        local taskName = Text:new({
            content = "[" .. task.id .. "]" .. task.text,
            width = 25,
            height = 1,
            onClick = function()
                NavigationBar.addNavigationBarItem(task.id, task.id, function()
                    os.queueEvent("toggle_view", "ticket", task)
                end)
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

        local deleteButton = Button:new({
            label = "Delete",
            width = 7,
            height = 1,
            textColor = colors.red,
            onClick = function()
                table.remove(tasks, i)
                NavigationBar.removeNavigationBarItem(task.id)
                saveTasks(tasks)
            end
        })

        ticketRow:addChild(taskName)
        ticketRow:addChild(taskStatus)
        ticketRow:addChild(deleteButton)

        ticketsColumn:addChild(ticketRow)
    end


    local bottomBar = Row:new({
        width = ticketDispalyWidth,
        height = 1,
    })
    local createTicketButton = Button:new({
        label = "Add",
        width = 7,
        height = 1,
        textColor = colors.green,
        onClick = function()
            local newTask = {
                id = "mc" .. math.random(1000, 9999),
                text = "New Task",
                status = 1,
                priority = 1,
            }
            os.queueEvent("toggle_view", "ticket", newTask)
            NavigationBar.addNavigationBarItem(newTask.id, newTask.id, function()
                os.queueEvent("toggle_view", "ticket", newTask)
            end
            )
            table.insert(tasks, newTask)
            saveTasks(tasks)
        end
    })
    bottomBar:addChild(createTicketButton)

    summaryScreenNode:addChild(NavigationBar.getNavBar())
    summaryScreenNode:addChild(titleRow)
    summaryScreenNode:addChild(ticketsColumn)
    summaryScreenNode:addChild(bottomBar)
    return summaryScreenNode
end

return SummaryScreenModule
