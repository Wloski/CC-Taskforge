-- register utils
require("taskforge/utils/utils_provider")
local DI = require("taskforge/di/di")
local monitorUtils = DI.get("monitorUtils")
local navigator = require("taskforge/navigation/navigator")


navigator.to("jira")
local currentView = navigator.getCurrentScreen()

local function screenLoop(screen, clickEvent)
    term.clear()
    currentView:draw(term)
    local event, parma, parma2, parma3 = os.pullEvent()
    if (event == "toggle_view") then
        navigator.to(parma, parma2)
    elseif (event == "back") then
        navigator.back()
    elseif (event == "mouse_click") then
        currentView:handleTouch(parma2, parma3)
    end
    currentView = navigator.getCurrentScreen()
end



parallel.waitForAny(
    function()
        while true do
            local event, parma, parma2, parma3 = os.pullEvent()
            if (event == "key") then
                if parma == keys.q then
                    term.clear()
                    term.setCursorPos(1, 1)
                    monitorUtils.monitor.clear()
                    break
                end
            end
        end
    end,
    function()
        while true do
            monitorUtils.monitor.clear()
            currentView:draw(monitorUtils.monitor)
            local event, parma, parma2, parma3 = os.pullEvent()
            if (event == "toggle_view") then
                navigator.to(parma, parma2)
            elseif (event == "back") then
                navigator.back()
            elseif (event == "monitor_touch") then
                currentView:handleTouch(parma2, parma3)
            end
            currentView = navigator.getCurrentScreen()
        end
    end
)
