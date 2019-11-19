--数据中心

local ShopData = require("ApplicationLayer/DataCenter/ShopData")        --商店数据
local PlayerInfo = require("ApplicationLayer/DataCenter/PlayerInfo")      --玩家信息
local MapData = require("ApplicationLayer/DataCenter/MapData")      --对战大厅的地图选择


local function GetShopData()
    return ShopData
end

local function GetPlayerInfo()
    return PlayerInfo
end

local function GetMapInfo()
    return MapData
end

return {
    GetShopData = GetShopData,      --商店，
    GetPlayerInfo = GetPlayerInfo,      --玩家信息，
    GetMapInfo = GetMapInfo,        --地图信息
}