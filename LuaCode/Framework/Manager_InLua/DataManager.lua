--初始化，加载到内存

local ActiveData = require("ApplicationLayer/DataCenter/ActiveData")        --活动中心
local ShopData = require("ApplicationLayer/DataCenter/ShopData")        --商店数据
local PlayerInfo = require("ApplicationLayer/DataCenter/PlayerInfo")      --玩家信息
local MapData = require("ApplicationLayer/DataCenter/MapData")      --对战大厅的地图选择

--数据中心
local DataManager = {};
function DataManager.GetActiveData()
    return ActiveData
end

function DataManager.GetShopData()
    return ShopData
end

function DataManager.GetPlayerInfo()
    return PlayerInfo
end

function DataManager.GetMapInfo()
    return MapData
end

return DataManager;