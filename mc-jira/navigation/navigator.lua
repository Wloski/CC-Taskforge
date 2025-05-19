local SummaryScreenModule = require("mc-jira/ui/screens/summary_screen")
local JiraBoardModule = require("mc-jira/ui/screens/jira_board")
local screenProvider = require("mc-jira/ui/screens/screen_provider")
local TicketScreenModule = require("mc-jira/ui/screens/ticket_screen")

local navigator = {
    nameToId = {},
    idToModule = {}
}

local currentModuleName = nil
local paramaterToPass = nil

navigator.nameToId["summary"] = SummaryScreenModule.id
navigator.idToModule[SummaryScreenModule.id] = function() return screenProvider.getSummaryScreen() end

navigator.nameToId["jira"] = JiraBoardModule.id
navigator.idToModule[JiraBoardModule.id] = function() return screenProvider.getJiraBoardScreen() end

navigator.nameToId["ticket"] = TicketScreenModule.id
navigator.idToModule[TicketScreenModule.id] = function() return screenProvider.getTicketScreen(paramaterToPass) end

function navigator.getIdByName(name)
    return navigator.nameToId[name]
end

function navigator.getModuleById(id)
    return navigator.idToModule[id]
end

function navigator.getModuleByName(name)
    return navigator.getModuleById(navigator.getIdByName(name))
end

function navigator.to(name, param)
    currentModuleName = name
    paramaterToPass = param
end

function navigator.getCurrentScreen()
    -- Execute function inline
    return (navigator.getModuleByName(currentModuleName))()
end

return navigator