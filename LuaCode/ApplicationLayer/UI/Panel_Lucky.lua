--补给码头（抽奖模块）

local BaseUI = require("Framework/Base/BaseUI")
local Panel_Lucky = Class("Panel_Lucky", BaseUI)

function Panel_Lucky:On_Init(args)
    --初始化
    self.uitable.ImagePro_Card1_Get10:AddClickListener(self.OnClickJinBi10)
    self.uitable.ImagePro_Card2_Get10:AddClickListener(self.OnClickDianJuan10)
    self.uitable.ImagePro_FromLuckyReturnToMain:AddClickListener(self.OnClick_Close)
end

--当点击关闭
function Panel_Lucky.OnClick_Close()
    UIManager.CloseUI()
end

--点击金币十连抽
function Panel_Lucky:OnClickJinBi10()
    UIManager.OpenUI("ApplicationLayer/UI/Panel_LuckyResult")
end

--点击金币十连抽
function Panel_Lucky:OnClickDianJuan10()
    UIManager.OpenUI("ApplicationLayer/UI/Panel_LuckyResult")
end

function Panel_Lucky:On_Show()
    --当打开时
    self.canvas_group.alpha = 1
    self.uitable.ImagePro_Bg.Rt.anchoredPosition = Vector2(0, -800)
    self.tweener = self.uitable.ImagePro_Bg.Rt:DOAnchorPos(Vector2(0, 0), 0.7)
    self.tweener:SetAutoKill(false)
end

--[[--出栈
function Panel_Lucky:On_Re_Show()
    self.canvas_group.alpha = 1
end

--入栈
function Panel_Lucky:On_Hide()
    self.canvas_group.alpha = 0
end]]

function Panel_Lucky:On_Close()
    --当关闭时
    self.canvas_group:DOFade(0, 0.6)
    self.tweener:PlayBackwards()             --DoTween 的反向使用
end

return Panel_Lucky
