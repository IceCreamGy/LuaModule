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
    UIManager.OpenUI("ApplicationLayer/UI/BuJi/Panel_BuJiResult")
end

--点击金币十连抽
function Panel_BuJi:OnClickDianJuan10()
    UIManager.OpenUI("ApplicationLayer/UI/BuJi/Panel_BuJiResult")
end

function Panel_BuJi:On_Show()
    --当打开时
    self.CG.alpha = 1
    self.uitable.ImagePro_Bg.Rt.anchoredPosition = Vector2(0, -800)
    self.tweener = self.uitable.ImagePro_Bg.Rt:DOAnchorPos(Vector2(0, 0), 0.45)
    self.tweener:SetAutoKill(false)
end

function Panel_BuJi:On_Close()
    --当关闭时
    self.CG:DOFade(0, 0.45)
    self.tweener:PlayBackwards()             --DoTween 的反向使用
end

return Panel_BuJi
