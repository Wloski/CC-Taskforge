local Node = require("taskforge/ui/base.node")
local Button = require("taskforge/ui/base.button")
local Text = require("taskforge/ui/base.text")
local Column = require("taskforge/ui/base.column")
local Row = require("taskforge/ui/base.row")
local colorList = require("taskforge/utils/colors")

local DI = require("taskforge/di/di")
local monitorUtils = DI.get("monitorUtils")

local NavigationBarModule = {}
local dynamicItems = {}
local navigationBar = Row:new({
    width = monitorUtils.width - 2,
    height = 1,
    backgroundColor = colors.gray
})

navigationBar:addChild(Text:new({
    content = "|Summary|",
    width = 9,
    centerText = false,
    onClick = function()
        os.queueEvent("toggle_view", "summary")
    end
}))

navigationBar:addChild(Text:new({
    content = "Board|",
    width = 6,
    centerText = false,
    onClick = function()
        os.queueEvent("toggle_view", "jira")
    end
}))

function NavigationBarModule.getNavBar()
    return navigationBar
end

function NavigationBarModule.findNavBarChildIndexById(id)
    for idx, child in ipairs(navigationBar.children) do
        if child.id == id then
            return idx
        end
    end
    return nil
end

function NavigationBarModule.addNavigationBarItem(_id, _text, _onClick)
    local row = Row:new({
        id = _id,
        width = string.len(_text) + 3,
        height = 1,
        backgroundColor = colors.gray
    })
    table.insert(dynamicItems, row.id)
    local itemName = Text:new({
        content = _text .. " ",
        width = string.len(_text) + 1,
        centerText = false,
        onClick = _onClick
    })

    local deleteItem = Text:new({
        content = "x|",
        width = 2,
        centerText = false,
        onClick = function()
            table.remove(
                NavigationBarModule.getNavBar().children,
                NavigationBarModule.findNavBarChildIndexById(row.id)
            )
            navigationBar:Redraw()
            os.queueEvent("toggle_view", "summary")
        end
    })

    row:addChild(itemName)
    row:addChild(deleteItem)
    navigationBar:addChild(row)

    local totalChildWidth = 0
    for _, child in ipairs(navigationBar.children) do
        totalChildWidth = totalChildWidth + child.width
        if (totalChildWidth > monitorUtils.width) then
            print("adding: " .. row.id)
            print(#dynamicItems - 1)
            table.remove(
                NavigationBarModule.getNavBar().children,
                NavigationBarModule.findNavBarChildIndexById(dynamicItems[#dynamicItems - 1])
            )
            table.remove(dynamicItems, #dynamicItems - 1)
        end
        navigationBar:Redraw()
    end

    return row.id
end

function NavigationBarModule.removeNavigationBarItem(id)
    local rowId = NavigationBarModule.findNavBarChildIndexById(id)
    if rowId == nil then
        return
    end
    table.remove(
        NavigationBarModule.getNavBar().children,
        rowId
    )
    navigationBar:Redraw()
end

return NavigationBarModule
