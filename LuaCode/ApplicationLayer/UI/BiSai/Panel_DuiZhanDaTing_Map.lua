--对战大厅的地图选择

local MapItem = require("ApplicationLayer/UI/BiSai/Panel_DuiZhanDaTing_MapItem")

local BaseUI = require("Framework/Base/BaseUI")
local Panel_DuiZhanDaTing_Map = Class("Panel_DuiZhanDaTing_Map", BaseUI)
Panel_DuiZhanDaTing_Map.MapItems = {}
Panel_DuiZhanDaTing_Map.mapLenght = 0
Panel_DuiZhanDaTing_Map.index = 1
Panel_DuiZhanDaTing_Map.mapData = nil


function Panel_DuiZhanDaTing_Map:On_Init(args)
    Panel_DuiZhanDaTing_Map.mapData = DataManager.GetMapInfo()
    Panel_DuiZhanDaTing_Map.mapLenght = #Panel_DuiZhanDaTing_Map.mapData
    Panel_DuiZhanDaTing_Map.mapItemGo = LoadManager.LoadGameObject("UI/BiSai/Panel_DuiZhanDaTing_MapItem")
    Panel_DuiZhanDaTing_Map.putPos = self.panel.transform:Find("ScrollView_MapContainer/Viewport/Content")

    Panel_DuiZhanDaTing_Map.CreatMapItem()

    self.uitable.ImagePro_Return:AddClickListener(self.OnClick_Close)
end

function Panel_DuiZhanDaTing_Map.CreatMapItem()
    LoadManager.CopyUI_WithParent(Panel_DuiZhanDaTing_Map.mapItemGo, Panel_DuiZhanDaTing_Map.putPos, function(go, uitable)
        local createdButton = MapItem.New(go, uitable, Panel_DuiZhanDaTing_Map.mapData[Panel_DuiZhanDaTing_Map.index])
        Panel_DuiZhanDaTing_Map.MapItems[Panel_DuiZhanDaTing_Map.mapData[Panel_DuiZhanDaTing_Map.index]] = createdButton
        Panel_DuiZhanDaTing_Map.index = Panel_DuiZhanDaTing_Map.index + 1

        if (Panel_DuiZhanDaTing_Map.index < Panel_DuiZhanDaTing_Map.mapLenght) then
            TimerManager.Add(0.2 , 1, Panel_DuiZhanDaTing_Map.CreatMapItem)
        end
    end)
end

function Panel_DuiZhanDaTing_Map.OnClick_Close()
    UIManager.CloseUI()
end

function Panel_DuiZhanDaTing_Map:On_Show()
    self.CG.alpha = 1
end

function Panel_DuiZhanDaTing_Map:On_Close()
    self.CG.alpha = 0
end

return Panel_DuiZhanDaTing_Map