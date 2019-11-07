--对战大厅的地图选择

local MapItem = require("ApplicationLayer/UI/BiSai/Panel_DuiZhanDaTing_MapItem")

local BaseUI = require("Framework/Base/BaseUI")
local Panel_DuiZhanDaTing_Map = Class("Panel_DuiZhanDaTing_Map", BaseUI)
local MapItems = {}

local mapItemGo = nil
local putPos = nil

local mapData = nil
local index = 1
local mapLenght = 0

function Panel_DuiZhanDaTing_Map:On_Init(args)
    mapData = DataManager.GetMapInfo()
    mapLenght = #mapData
    mapItemGo = LoadManager.LoadGameObject("UI/BiSai/Panel_DuiZhanDaTing_MapItem")
    putPos = self.panel.transform:Find("ScrollView_MapContainer/Viewport/Content")

    for i, v in ipairs(mapData) do
        LoadManager.CopyUI_WithParent(mapItemGo, putPos, function(go, uitable)
            local createdButton = MapItem.New(go, uitable, v)
            MapItems[v.MapId] = createdButton
        end)
    end

    self.uitable.ImagePro_Return:AddClickListener(self.OnClick_Close)
end

function Panel_DuiZhanDaTing_Map.OnClick_Close()
    UIManager.CloseUI()
end

function Panel_DuiZhanDaTing_Map:On_Show()
    self.CG.alpha = 1
    index = 1
    self.ShowTween()
end

function Panel_DuiZhanDaTing_Map:On_Close()
    self.CG.alpha = 0

    for i, v in ipairs(mapData) do
        MapItem.Hide(MapItems[i])
    end
end

function Panel_DuiZhanDaTing_Map.ShowTween()
    MapItem.PlayTween(MapItems[index])
    index = index + 1

    if (index < mapLenght) then
        TimerManager.Add(0.2, 1, Panel_DuiZhanDaTing_Map.ShowTween)
    end
end

return Panel_DuiZhanDaTing_Map