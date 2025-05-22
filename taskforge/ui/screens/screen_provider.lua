local KanbanBoardModule = require("taskforge/ui/screens/kanban_board")
local SummaryScreenModule = require("taskforge/ui/screens/summary_screen")
local TicketScreenModule = require("taskforge/ui/screens/ticket_screen")

local DI = require("taskforge/di/di")
local taskUtils = DI.get("taskUtils")
local monitorUtils = DI.get("monitorUtils")
local configUtils = DI.get("configUtils")

local ScreenProvider = {}
function ScreenProvider.getKanbanBoardScreen()
    local _tasks = taskUtils:loadTasks()
    KanbanBoardModule:build(
        _tasks,
        function(tasks)
            taskUtils:saveTasks(tasks)
        end,
        function(task, status)
            taskUtils:moveTask(task, status)
        end,
        configUtils.getConfig(),
        monitorUtils.width,
        monitorUtils.height
    )
    return KanbanBoardModule:create()
end

function ScreenProvider.getSummaryScreen()
    local _tasks = taskUtils:loadTasks()
    SummaryScreenModule:build(
        _tasks,
        function(tasks)
            taskUtils:saveTasks(tasks)
        end,
        function(status)
            return taskUtils:getStatusColor(status)
        end,
        configUtils.getConfig(),
        monitorUtils.width,
        monitorUtils.height
    )
    return SummaryScreenModule:create()
end

function ScreenProvider.getTicketScreen(ticket)
    TicketScreenModule:build(
        ticket,
        function(tasks)
            taskUtils:saveTask(tasks)
        end,
        function(id)
            taskUtils:deleteTaskById(id)
        end,
        function(status)
            return taskUtils:getStatusColor(status)
        end,
        configUtils.getConfig(),
        monitorUtils.width,
        monitorUtils.height
    )
    return TicketScreenModule:create()
end

return ScreenProvider
