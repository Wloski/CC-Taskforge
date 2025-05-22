local SummaryScreenModule = require("taskforge/ui/screens/summary_screen")
local kanbanBoardModule = require("taskforge/ui/screens/kanban_board")
local screenProvider = require("taskforge/ui/screens/screen_provider")
local TicketScreenModule = require("taskforge/ui/screens/ticket_screen")

local navigator = {
    nameToId = {},
    idToModule = {}
}
local stack = {}
local currentModuleName = nil
local paramaterToPass = nil

navigator.nameToId["summary"] = SummaryScreenModule.id
navigator.idToModule[SummaryScreenModule.id] = function() return screenProvider.getSummaryScreen() end

navigator.nameToId["jira"] = kanbanBoardModule.id
navigator.idToModule[kanbanBoardModule.id] = function() return screenProvider.getKanbanBoardScreen() end

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
    table.insert(stack, { currentModuleName = name, paramaterToPass = param })
end

function navigator.back()
    local navItem = stack[#stack - 1]
    if (navItem == nil) then
        return
    end
    currentModuleName = navItem.currentModuleName
    paramaterToPass = navItem.paramaterToPass
    table.remove(stack, #stack)
    table.remove(stack, #stack)
end

function navigator.getCurrentScreen()
    -- Execute function inline
    return (navigator.getModuleByName(currentModuleName))()
end

return navigator
