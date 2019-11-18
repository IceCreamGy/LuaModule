--主场景初始面板（大厅）
local Panel_MainScene = Class("Panel_MainScene", BaseUI)

--暂存变量
local GameObjectPanel

function Panel_MainScene:On_Init(args)
    GameObjectPanel = self.gameObject

    Panel_MainScene.InitDownPanel()     --加载下方栏
    TimerManager_InCS.Add(0.4,1,Panel_MainScene.InitUpPanel)     --加载上方栏
    TimerManager_InCS.Add(0.7,1,Panel_MainScene.InitLeftPanel)       --加载左边栏
end

function Panel_MainScene.InitUpPanel()
    UIManager.OpenPoPupUI("Panel_WindowOnUp",nil)
end

function Panel_MainScene.InitDownPanel()
    UIManager.OpenPoPupUI("Panel_WindowOnBelow",nil,GameObjectPanel)
end

function Panel_MainScene.InitLeftPanel()
    UIManager.OpenPoPupUI("Panel_WindowOnLeft",nil, GameObjectPanel)
end

function Panel_MainScene:On_ReShow()
    self.CG.alpha = 1
end
function Panel_MainScene:On_Hide()
    self.CG.alpha = 0
end

return Panel_MainScene
