local JiraBoardModule = require("mc-jira/ui/screens/jira_board")
local MainScreenModule = require("mc-jira/ui/screens/main_screen")

local DI = require("mc-jira/di/di")
local taskUtils = DI.get("taskUtils")
local monitorUtils = DI.get("monitorUtils")

local ScreenProvider = {}
function ScreenProvider.getJiraBoardScreen()
    local _tasks = taskUtils:loadTasks()
    JiraBoardModule:build(
        _tasks, 
        function(tasks)
            taskUtils:saveTasks(tasks)
        end,
        monitorUtils.width,
        monitorUtils.height
    )
    return JiraBoardModule:create()
end

function ScreenProvider.getMainScreen()
    local _tasks = taskUtils:loadTasks()
    MainScreenModule:build(
        _tasks, 
        function(tasks)
            taskUtils:saveTasks(tasks)
        end,
        monitorUtils.width,
        monitorUtils.height
    )
    return MainScreenModule:create()
end

return ScreenProvider