local Node = require("mc-jira/ui/base.node")
local Button = require("mc-jira/ui/component.button")
local Text = require("mc-jira/ui/component.text")
local Column = require("mc-jira/ui/component.column")
local Row = require("mc-jira/ui/component.row")
local colorList = require("mc-jira/utils/colors")
local NavigationBar = require("mc-jira/ui/component.navigation_bar")
local BaseScreen = require("mc-jira/ui/screens/base_screen")

local monitorWidth = 0
local monitorHeight = 0

local configFile = fs.open("mc-jira/data/config.json", "r") or {}
local config = textutils.unserializeJSON(configFile.readAll())
configFile.close()
local COLS = config.COLS

local tasks = {}
local saveTasks = nil

local MainScreenModule = BaseScreen:new()
function MainScreenModule:build(_tasks, _saveTasks, _monitorWidth, _monitorHeight)
    tasks = _tasks
    saveTasks = _saveTasks
    monitorWidth = _monitorWidth
    monitorHeight = _monitorHeight
end

function MainScreenModule:create(monitor)
    local mainScreenNode = Node:new({ width = monitorWidth, height = monitorHeight })
    local titleRow = Row:new({
        width = monitorWidth - 2,
        height = 1,
        backgroundColor = colors.blue,
    })
    local title = Text:new({
        content = "MC-JIRA",
        color = colorList.white,
        width = monitorWidth - 2,
        height = 1,
        centerText = true,
        backgroundColor = colors.blue,
    })
    titleRow:addChild(title)

    local ticketDispalyWidth = 40
    local ticketsColumn = Column:new({
        width = ticketDispalyWidth,
        height = 20,
    })
    for i = 1, #tasks do
        local task = tasks[i]
        local ticketRow = Row:new({
            width = ticketDispalyWidth,
            height = 1,
            padding = 1,
        })

        if task.status == 2 then
            textColor = colors.blue
        elseif task.status == 3 then
            textColor = colors.green
        else
            textColor = colors.gray
        end
        local taskName = Text:new({
            content = "[" .. tasks[i].id .. "]" .. tasks[i].text,
            width = 30,
            height = 1,
        })

        local taskStatus = Text:new({
            content = COLS[task.status],
            width = 15,
            height = 1,
            textColor = textColor,
            onClick = function()
                print("Clicked on task: " .. task.id)
                if (task.status == #COLS) then
                    task.status = 1
                else
                    task.status = task.status + 1
                end
                saveTasks(tasks)
            end
        })
        ticketRow:addChild(taskName)
        ticketRow:addChild(taskStatus)

        ticketsColumn:addChild(ticketRow)
    end

    mainScreenNode:addChild(NavigationBar)
    mainScreenNode:addChild(titleRow)
    mainScreenNode:addChild(ticketsColumn)

    return mainScreenNode
end

return MainScreenModule
    