local DI = require("mc-jira/di/di")
local taskModule = require("mc-jira/utils/task_utils")
local monitorModule = require("mc-jira/utils/monitor_utils")
local SAVE_PATH = "mc-jira/data/tasks.json"

DI.register("taskUtils", 
    function()
        return taskModule.new(fs, textutils, SAVE_PATH)
    end
)

DI.register("monitorUtils",
    function()
        return monitorModule
    end
)