-- register utils
require("mc-jira/utils/utils_provider")
local DI = require("mc-jira/di/di")
local monitorUtils = DI.get("monitorUtils")
local navigator = require("mc-jira/navigation/navigator")


navigator.to("jira")
local currentView = navigator.getCurrentScreen()
parallel.waitForAny(
    function()
        while true do
            local event, key = os.pullEvent("key")
            if key == keys.q then
                term.clear()
                term.setCursorPos(1, 1)
                monitorUtils.monitor.clear()
                os.exit()
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
