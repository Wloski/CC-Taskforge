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
                os.exit()
            end
        end
    end,
    function()
        while true do
            monitorUtils.monitor.clear()
            currentView:draw(monitorUtils.monitor)
            local event, side, x, y = os.pullEvent()
            if (event == "toggle_view") then
                navigator.to(side)
            elseif (event == "monitor_touch") then
                currentView:handleTouch(x, y)
            end
            currentView = navigator.getCurrentScreen()
        end
    end
)