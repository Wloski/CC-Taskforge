local JiraBoardModule = require("mc-jira/ui/screens/jira_board")
local SummaryScreenModule = require("mc-jira/ui/screens/summary_screen")
local TicketScreenModule = require("mc-jira/ui/screens/ticket_screen")

local DI = require("mc-jira/di/di")
local taskUtils = DI.get("taskUtils")
local monitorUtils = DI.get("monitorUtils")
local configUtils = DI.get("configUtils")

local ScreenProvider = {}
function ScreenProvider.getJiraBoardScreen()
    local _tasks = taskUtils:loadTasks()
    JiraBoardModule:build(
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
    return JiraBoardModule:create()
end

function ScreenProvider.getSummaryScreen()
    local _tasks = taskUtils:loadTasks()
    SummaryScreenModule:build(
        _tasks,
        function(tasks)
            taskUtils:saveTasks(tasks)
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
        configUtils.getConfig(),
        monitorUtils.width,
        monitorUtils.height
    )
    return TicketScreenModule:create()
end

return ScreenProvider