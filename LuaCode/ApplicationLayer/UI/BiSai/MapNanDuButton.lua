--比赛地图筛选按钮
--全部，简单，中等，困难。
--就不装逼用英文了，拼音吧。  MapNanDu  中英结合？  捂脸.jpg

local MapNanDuButton = Class("MapNanDuButton")
MapNanDuButton.StarLevel = nil      --难度星级，以后用来筛选展示的地图

function MapNanDuButton:ctor(uiToggle, starLevelParam)
    self.StarLevel = starLevelParam

    local function Select()
        uiToggle.Text_lable.color = Color.black
        UIManager.GetPanel("Panel_DuiZhanDaTing_Map").RefreshMapCar(self.StarLevel)
    end
    local function CancleSelect()
        uiToggle.Text_lable.color = Color.white
    end

    uiToggle:AddEvent(Select, CancleSelect)
end

return MapNanDuButton