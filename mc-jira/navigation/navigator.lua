local MainScreenModule = require("mc-jira/ui/screens/main_screen")
local JiraBoardModule = require("mc-jira/ui/screens/jira_board")
local screenProvider = require("mc-jira/ui/screens/screen_provider")

local navigator = {
    nameToId = {},
    idToModule = {}
}

local currentModuleName = nil

navigator.nameToId["main"] = MainScreenModule.id
navigator.idToModule[MainScreenModule.id] = function() return screenProvider.getMainScreen() end

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

function navigator.getCurrentModule()
    return (navigator.getModuleByName(currentModuleName))()
end

return navigator