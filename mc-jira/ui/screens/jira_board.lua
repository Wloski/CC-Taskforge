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
local VISIBLE_ROWS = config.VISIBLE_ROWS or 4
local saveTasks = nil

local scrollPositions = scrollPositions or {}
for i = 1, #COLS do
    scrollPositions[i] = scrollPositions[i] or 1
end

local JiraBoard = BaseScreen:new()
function JiraBoard:build(_tasks, _saveTasks, _monitorWidth, monitorHeight)
    tasks = _tasks
    saveTasks = _saveTasks
    monitorWidth = _monitorWidth
    monitorHeight = _monitorHeight
    if tasks == nil then
        print("Error loading tasks")
        return
    elseif saveTasks == nil then
        print("Error setting saveTasks jira_board : Line 34")
        return
    else
        return
    end
end

function JiraBoard:create()
    local node = Node:new({ width = monitorWidth, height = monitorHeight })

    local boardWidth = monitorWidth - 2
    local boardHeight = 15

    local titleRow = Row:new({ 
        y = 2, 
        width = boardWidth, 
        height = 1, 
        backgroundColor = colors.gray 
    })
    local rowTextWidth = boardWidth / #COLS
    for i = 1, #COLS do
        titleRow:addChild(Text:new({ 
            content = COLS[i], 
            width = rowTextWidth, 
            centerText = true
        }))
    end

    local jiraContentRow = Row:new({ width = (boardWidth), height = 40 })
    for i = 1, #COLS do
        local textColumn = Column:new({
            width = rowTextWidth,
            height = boardHeight,
            padding = 1,
        })
        
        local columnTasks = {}
        for y = 1, #tasks do
            local task = tasks[y]
            if task.status == i then
                task.color = colorList[((y - 1) % #colorList) + 1]
                table.insert(columnTasks, task)
            end
        end

        if scrollPositions[i] > math.max(1, #columnTasks - VISIBLE_ROWS + 1) then
            scrollPositions[i] = math.max(1, #columnTasks - VISIBLE_ROWS + 1)
        end

        local startIdx = scrollPositions[i]
        local endIdx = math.min(#columnTasks, startIdx + VISIBLE_ROWS - 1)
        for idx = startIdx, endIdx do
            local task = columnTasks[idx]
            local displayText = string.format("[%s] %s", task.id, task.text)
            textColumn:addChild(Text:new({
                content = displayText,
                width = textColumn.width,
                textColor = task.color,
                onClick = function()
                    if (task.status == #COLS) then
                        task.status = 1
                    else
                        task.status = task.status + 1
                    end
                    saveTasks(tasks)
                end
            }))
        end 

        if #columnTasks > VISIBLE_ROWS then
            local buttonRow = Row:new({
                width = textColumn.width,
                height = 1,
                backgroundColor = colors.gray
            })
            buttonRow:addChild(Button:new({
                label = "Up",
                width = 3,
                height = 1,
                onClick = function()
                    scrollPositions[i] = math.max(1, scrollPositions[i] - 1)
                end
            }))
            buttonRow:addChild(Button:new({
                label = "Down",
                width = 5,
                height = 1,
                onClick = function()
                    local maxScroll = math.max(1, #columnTasks - (VISIBLE_ROWS - 1))
                    scrollPositions[i] = math.min(maxScroll, scrollPositions[i] + 1)
                end
            }))
            textColumn:addChild(buttonRow)
        end

        jiraContentRow:addChild(textColumn)
        if (i <= #COLS - 1) then
            local spacer = Column:new({
                width = 1,
                height = boardHeight,
            })  
            jiraContentRow:addChild(spacer)
        end
    end

    node:addChild(NavigationBar)
    node:addChild(titleRow)
    node:addChild(jiraContentRow)

    return node
end

return JiraBoard