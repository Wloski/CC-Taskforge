local configFile = fs.open("taskforge/data/config.json", "r") or {}
local config = textutils.unserializeJSON(configFile.readAll())
configFile.close()

local ConfigUtils = {}
function ConfigUtils:getConfig()
    return config
end

return ConfigUtils
