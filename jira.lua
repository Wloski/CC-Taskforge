-- register utils
require("mc-jira/utils/utils_provider")
-- Utils
local DI = require("mc-jira/di/di")
local monitorUtils = DI.get("monitorUtils")

-- Ui
local Node = require("mc-jira/ui/base.node")
local Button = require("mc-jira/ui/component.button")
local Text = require("mc-jira/ui/component.text")
local Column = require("mc-jira/ui/component.column")
local Row = require("mc-jira/ui/component.row")

local navigator = require("mc-jira/navigation/navigator")


navigator.to("jira")
local currentView = navigator.getCurrentModule()
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
                print(side)
                navigator.to(side)
            elseif (event == "monitor_touch") then
                currentView:handleTouch(x, y)
            end
            currentView = navigator.getCurrentModule()
        end
    end
)