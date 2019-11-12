--主场景初始面板（大厅）
local BaseUI = require("Framework/Base/BaseUI")
local Panel_MainScene = Class("Panel_MainScene", BaseUI)

--暂存变量
local GameObjectPanel

function Panel_MainScene:On_Init(args)
    GameObjectPanel = self.panel

    Panel_MainScene.InitDownPanel()     --加载下方栏
    TimerManager.Add(0.4,1,Panel_MainScene.InitUpPanel)     --加载上方栏
    TimerManager.Add(0.7,1,Panel_MainScene.InitLeftPanel)       --加载左边栏
end

function Panel_MainScene.InitUpPanel()
    UIManager.OpenPoPupUI("ApplicationLayer/UI/MainScene/Main/Panel_WindowOnUp",nil,GameObjectPanel)
end

function Panel_MainScene.InitDownPanel()
    UIManager.OpenPoPupUI("ApplicationLayer/UI/MainScene/Main/Panel_WindowOnBelow",nil,GameObjectPanel)
end

function Panel_MainScene.InitLeftPanel()
    UIManager.OpenPoPupUI("ApplicationLayer/UI/MainScene/Main/Panel_WindowOnLeft",nil, GameObjectPanel)
end


return Panel_MainScene
