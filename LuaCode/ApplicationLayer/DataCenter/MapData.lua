--地图选择卡相关的数据
local MapData = {}

MapData[1] = {
    MapId = 1,
    MapName = "幺街",
    MapStar = 1,
    License = 0, --驾照0，代表不需要。   1初级，2中级，3高级
    LicenseExplain = "新手即可", --限制描述
    MapSelectBg = "UI/Map/MapSelect/23_Level_Yaojie01",
    MapLodingBg = "UI/Map/MapLoading/21_Level_Yaojie01"
}
MapData[2] = {
    MapId = 2,
    MapName = "西部峡谷",
    MapStar = 2,
    License = 0,
    LicenseExplain = "新手即可",
    MapSelectBg = "UI/Map/MapSelect/23_Level_Canyon01",
    MapLodingBg = "UI/Map/MapLoading/21_Level_Canyon01"
}
MapData[3] = {
    MapId = 3,
    MapName = "城郊码头",
    MapStar = 2,
    License = 0,
    LicenseExplain = "新手即可",
    MapSelectBg = "UI/Map/MapSelect/23_Level_Macau01",
    MapLodingBg = "UI/Map/MapLoading/21_Level_Macau01"
}
MapData[4] = {
    MapId = 4,
    MapName = "完美训练场",
    MapStar = 2,
    License = 0,
    LicenseExplain = "新手即可",
    MapSelectBg = "UI/Map/MapSelect/23_Level_TrainingF101",
    MapLodingBg = "UI/Map/MapLoading/21_Level_TrainingF101"
}
MapData[5] = {
    MapId = 5,
    MapName = "城堡酒庄",
    MapStar = 2,
    License = 0,
    LicenseExplain = "新手即可",
    MapSelectBg = "UI/Map/MapSelect/23_Level_NapaValley02",
    MapLodingBg = "UI/Map/MapLoading/21_Level_NapaValley02"
}
MapData[6] = {
    MapId = 6,
    MapName = "海港",
    MapStar = 3,
    License = 1,
    LicenseExplain = "初级驾照解锁",
    MapSelectBg = "UI/Map/MapSelect/23_Level_Seaport01",
    MapLodingBg = "UI/Map/MapLoading/21_Level_Seaport01"
}
MapData[7] = {
    MapId = 7,
    MapName = "上海F1-晴天",
    MapStar = 4,
    License = 1,
    LicenseExplain = "初级驾照解锁",
    MapSelectBg = "UI/Map/MapSelect/23_Level_ShangHaiF101",
    MapLodingBg = "UI/Map/MapLoading/21_Level_ShangHaiF101"
}
MapData[8] = {
    MapId = 8,
    MapName = "城堡酒庄-反向",
    MapStar = 4,
    License = 2,
    LicenseExplain = "中级驾照解锁",
    MapSelectBg = "UI/Map/MapSelect/23_Level_NapaValley01",
    MapLodingBg = "UI/Map/MapLoading/21_Level_NapaValley01"
}
MapData[9] = {
    MapId = 9,
    MapName = "黑夜都市",
    MapStar = 4,
    License = 2,
    LicenseExplain = "中级驾照解锁",
    MapSelectBg = "UI/Map/MapSelect/23_Level_Xibanya",
    MapLodingBg = "UI/Map/MapLoading/21_Level_Xibanya"
}

return MapData