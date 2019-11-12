--对战大厅的地图选择

local MapItem = require("ApplicationLayer/UI/MainScene/BiSai/Panel_DuiZhanDaTing_MapItem")
local NanDuButtonItem = require("ApplicationLayer/UI/MainScene/BiSai/MapNanDuButton")

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

    self:InitLevelSelectButton()
    self:InitMapCard()
    self.uitable.ImagePro_Return:AddClickListener(self.OnClick_Close)
end

--初始化 难度选择的按钮
function Panel_DuiZhanDaTing_Map:InitLevelSelectButton()
    NanDuButtonItem.New(self.uitable.TogglePro_All, "all")
    NanDuButtonItem.New(self.uitable.TogglePro_JianDan, "simple")
    NanDuButtonItem.New(self.uitable.TogglePro_ZhongDeng, "medium")
    NanDuButtonItem.New(self.uitable.TogglePro_KunNan, "difficulty")
end

--初始化 地图选择卡片的加载
function Panel_DuiZhanDaTing_Map:InitMapCard()
    mapLenght = #mapData
    mapItemGo = LoadManager.LoadGameObject("UI/BiSai/Panel_DuiZhanDaTing_MapItem")
    putPos = self.panel.transform:Find("ScrollView_MapContainer/Viewport/Content")

    for i, v in ipairs(mapData) do
        LoadManager.CopyUI_WithParent(mapItemGo, putPos, function(go, uitable)
            local createdButton = MapItem.New(go, uitable, v)
            MapItems[v.MapId] = createdButton
        end)
    end
end

--根据难度刷新卡片
function Panel_DuiZhanDaTing_Map.RefreshMapCar(NanDuStar)
    local function RefreshSome()
        for k, v in pairs(MapItems) do
            if (v.data.NanDu == NanDuStar) then
                v.Go:SetActive(true)
                MapItem.PlayTweenOnlyCG(v)
            else
                v.Go:SetActive(false)
            end
        end
    end
    local function RefreshAll()
        for k, v in pairs(MapItems) do
            v.Go:SetActive(true)
            MapItem.PlayTweenOnlyCG(v)
        end
    end

    if (NanDuStar == "all") then
        RefreshAll()
    else
        RefreshSome()
    end
end

function Panel_DuiZhanDaTing_Map.OnClick_Close()
    UIManager.CloseUI()
end

function Panel_DuiZhanDaTing_Map:On_Show()
    self.CG.alpha = 1
    index = 1

    --self. RefreshMapCar("all")
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

    if (index <= mapLenght) then
        TimerManager.Add(0.2, 1, Panel_DuiZhanDaTing_Map.ShowTween)
    end
end

return Panel_DuiZhanDaTing_Map