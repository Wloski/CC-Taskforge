local SummaryScreenModule = require("mc-jira/ui/screens/summary_screen")
local JiraBoardModule = require("mc-jira/ui/screens/jira_board")
local screenProvider = require("mc-jira/ui/screens/screen_provider")

local navigator = {
    nameToId = {},
    idToModule = {}
}

local currentModuleName = nil

navigator.nameToId["summary"] = SummaryScreenModule.id
navigator.idToModule[SummaryScreenModule.id] = function() return screenProvider.getSummaryScreen() end

navigator.nameToId["jira"] = JiraBoardModule.id
navigator.idToModule[JiraBoardModule.id] = function() return screenProvider.getJiraBoardScreen() end

function navigator.getIdByName(name)
    return navigator.nameToId[name]
end

function navigator.getModuleById(id)
    return navigator.idToModule[id]
end

function navigator.getModuleByName(name)
    return navigator.getModuleById(navigator.getIdByName(name))
end

function navigator.to(name)
    currentModuleName = name
end

function navigator.getCurrentScreen()
    return (navigator.getModuleByName(currentModuleName))()
end

return navigator