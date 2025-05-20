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
local VISIBLE_ROWS = nil

local saveTask = nil
local moveTask = nil
local tasks = {}




local scrollPositions = scrollPositions or {}


local JiraBoard = BaseScreen:new()
function JiraBoard:build(_tasks, _saveTask, _moveTask, _config, _monitorWidth, _monitorHeight)
    tasks = _tasks
    saveTask = _saveTask
    moveTask = _moveTask
    monitorWidth = _monitorWidth
    monitorHeight = _monitorHeight
    
    -- Setup config items
    COLS = _config.COLS
    VISIBLE_ROWS = _config.VISIBLE_ROWS or 4
    for i = 1, #COLS do
        scrollPositions[i] = scrollPositions[i] or 1
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
            centerTextEnabled = true
        }))
    end

    local jiraContentRow = Row:new({ width = (boardWidth), height = 40 })
    for i = 1, #COLS do
        local textColumn = Column:new({
            width = rowTextWidth,
            height = boardHeight,
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
                wrapTextEnabled = true,
                onClick = function()
                    local status = task.status
                    if (status == #COLS) then
                        status = 1
                    else
                        status = status + 1
                    end
                    moveTask(task, status)
                    saveTask(tasks)
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
                label = string.char(24),
                width = 3,
                height = 1,
                backgroundColor = colors.gray,
                centerTextEnabled = true,
                onClick = function()
                    scrollPositions[i] = math.max(1, scrollPositions[i] - 1)
                end
            }))
            buttonRow:addChild(Button:new({
                label = string.char(25),
                width = 3,
                height = 1,
                backgroundColor = colors.gray,
                centerTextEnabled = true,
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

    node:addChild(NavigationBar.getNavBar())
    node:addChild(titleRow)
    node:addChild(jiraContentRow)

    return node
end

return JiraBoard