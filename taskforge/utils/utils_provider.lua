local DI = require("taskforge/di/di")
local taskModule = require("taskforge/utils/task_utils")
local monitorModule = require("taskforge/utils/monitor_utils")
local configModule = require("taskforge/utils/config_utils")
local SAVE_PATH = "taskforge/data/tasks.json"

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

DI.register("configUtils",
    function()
        return configModule
    end
)
