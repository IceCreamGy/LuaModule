--主场景初始面板（大厅）
local BaseUI = require("Framework/Base/BaseUI")
local Panel_MainScene = Class("Panel_MainScene", BaseUI)

--暂存变量
local GameObjectPanel

function Panel_MainScene:On_Init(args)
    GameObjectPanel = self.panel

    local data = DataManager.GetPlayerInfo()
    --初始化 数据
    self:InitData(data)

    Panel_MainScene.InitDownPanel()     --加载下方栏
    TimerManager.Add(0.4,1,Panel_MainScene.InitLeftPanel)       --加载左边栏
end

function Panel_MainScene.InitDownPanel()
    UIManager.OpenPoPupUIWithParent("ApplicationLayer/UI/MainScene/Panel_WindowOnBelow", GameObjectPanel,nil)
end

function Panel_MainScene.InitLeftPanel()
    UIManager.OpenPoPupUIWithParent("ApplicationLayer/UI/MainScene/Panel_WindowOnLeft", GameObjectPanel,nil)
end

--初始化 数据
function Panel_MainScene:InitData(args)
    self.uitable.Text_Name.text = args.name               --改 Text
    self.uitable.Text_Level.text = args.level
    self.uitable.Image_PlayerIcon:SetImage(args.icon)       --改 Image
end

return Panel_MainScene
