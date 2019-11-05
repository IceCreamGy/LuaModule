--对战大厅的地图选择

local MapItem = require("ApplicationLayer/UI/BiSai/Panel_DuiZhanDaTing_MapItem")

local BaseUI = require("Framework/Base/BaseUI")
local Panel_DuiZhanDaTing_Map = Class("Panel_DuiZhanDaTing_Map", BaseUI)
Panel_DuiZhanDaTing_Map.MapItems = {}

function Panel_DuiZhanDaTing_Map:On_Init(args)
    local mapData = DataManager.GetMapInfo()
    local mapItemGo = LoadManager.LoadGameObject("UI/BiSai/Panel_DuiZhanDaTing_MapItem")
    local putPos = self.panel.transform:Find("ScrollView_MapContainer/Viewport/Content")
    for i, v in ipairs(mapData) do
        LoadManager.CopyUI_WithParent(mapItemGo, putPos, function(go, uitable)
            local createdButton = MapItem.New(go, uitable, v)
            Panel_DuiZhanDaTing_Map.MapItems[v.MapId] = createdButton
        end)
    end

    self.uitable.ImagePro_Return:AddClickListener(self.OnClick_Close)
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