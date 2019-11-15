--补给码头（抽奖模块）

local BaseUI = require("Framework/Base/BaseUI")
local Panel_BuJi = Class("Panel_BuJi", BaseUI)

function Panel_BuJi:On_Init(args)
    --初始化
    self.uitable.ImagePro_Card1_Get10:AddClickListener(self.OnClickJinBi10)
    self.uitable.ImagePro_Card2_Get10:AddClickListener(self.OnClickDianJuan10)
    self.uitable.ImagePro_FromLuckyReturnToMain:AddClickListener(self.OnClick_Close)
end

--当点击关闭
function Panel_BuJi.OnClick_Close()
    UIManager.CloseUI()
end

--点击金币十连抽
function Panel_BuJi:OnClickJinBi10()
    UIManager.OpenUI("Panel_BuJiResult")
end

--点击金币十连抽
function Panel_BuJi:OnClickDianJuan10()
    UIManager.OpenUI("Panel_BuJiResult")
end

function Panel_BuJi:On_Show()
    self.CG.alpha = 1
    self.uitable.ImagePro_Mask.Rt.sizeDelta = Vector2(0, 1080)
    self.uitable.ImagePro_Mask.Rt:DOSizeDelta(Vector2(1920, 1080), 0.4)
end

function Panel_BuJi:On_Close()
    local tweenerBack = self.uitable.ImagePro_Mask.Rt:DOSizeDelta(Vector2(0, 1080), 0.4)
    tweenerBack:OnComplete(function()
        self.CG.alpha = 0
        EventManager.DispachEvent(Event_InLua.ReturnMain)
    end)
end

return Panel_BuJi
