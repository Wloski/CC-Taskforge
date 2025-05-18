local Node = require("mc-jira/ui/base.node")
local Button = require("mc-jira/ui/base.button")
local Text = require("mc-jira/ui/base.text")
local Column = require("mc-jira/ui/base.column")
local Row = require("mc-jira/ui/base.row")
local colorList = require("mc-jira/utils/colors")

local navigationBar = Row:new({ 
    width = boardWidth, 
    height = 1, 
    backgroundColor = colors.gray 
})

navigationBar:addChild(Text:new({ 
    content = "| Summary |", 
    width = monitorWidth, 
    centerText = false,
    onClick = function()
        os.queueEvent("toggle_view", "summary")
    end
}))
navigationBar:addChild(Text:new({ 
    content = "| Board |", 
    width = monitorWidth, 
    centerText = false,
    onClick = function()
        os.queueEvent("toggle_view", "jira")
    end
}))


return navigationBar