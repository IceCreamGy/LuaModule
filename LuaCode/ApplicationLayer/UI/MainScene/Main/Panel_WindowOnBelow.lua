--主面板下方的一些按钮
--商城，补给码头，挑战赛事，多人对战，主线剧情

local BaseUI = require("Framework/Base/BaseUI")
local Panel_WindowOnBelow = Class("Panel_WindowOnBelow", BaseUI)

local buttons = {}
local AnchoredPosition = {}

--打开商店
local function ClickButton_OpenShop()
    UIManager.OpenUI("ApplicationLayer/UI/MainScene/Shop/Panel_Shop", nil)
end
--打开挑战
local function ClickButton_TiaoZhan()
    UIManager.OpenUI("ApplicationLayer/UI/MainScene/TiaoZhan/Panel_TiaoZhan", nil)
end
--打开补给码头
local function ClickButton_OpenSupply()
    UIManager.OpenUI("ApplicationLayer/UI/MainScene/BuJi/Panel_BuJi", nil)
end
--打开多人对战
local function ClickButton_BiSai()
    UIManager.OpenUI("ApplicationLayer/UI/MainScene/BiSai/Panel_BiSai", nil)
end
--打开剧情
local function ClickButton_JuQing()
    UIManager.OpenUI("ApplicationLayer/UI/MainScene/JuQing/Panel_JuQing", nil)
end


--为按钮添加动画
local function AddButtonAnimation(self)
    buttons[1] = self.uitable.ImagePro_OpenShop         --商城
    buttons[2] = self.uitable.ImagePro_OpenSupply       --码头
    buttons[3] = self.uitable.ImagePro_OpenRace         --赛事
    buttons[4] = self.uitable.ImagePro_OpenPVP          --PVP
    buttons[5] = self.uitable.ImagePro_OpenPVE          --PVE

    for i, v in ipairs(buttons) do
        v.CG.alpha = 0
        v.CG:DOFade(1, 0.3)

        AnchoredPosition[i] = v.Rt.anchoredPosition         --记录按钮的位置
        v.Rt.anchoredPosition = Vector2(AnchoredPosition[i].x, -150)                   --修改位置
        v.Rt:DOAnchorPos(AnchoredPosition[i], 0.1+i*0.13)          --DoTween 位置动画
    end
end

function Panel_WindowOnBelow:Init(args)

    AddButtonAnimation(self)

    self.uitable.Rt.anchoredPosition = Vector2(0, 0);

    self.uitable.ImagePro_OpenShop:AddClickListener(ClickButton_OpenShop)        --商店
    self.uitable.ImagePro_OpenSupply:AddClickListener(ClickButton_OpenSupply)    --码头
    self.uitable.ImagePro_OpenRace:AddClickListener(ClickButton_TiaoZhan)            --挑战
    self.uitable.ImagePro_OpenPVP:AddClickListener(ClickButton_BiSai)            --比赛
    self.uitable.ImagePro_OpenPVE:AddClickListener(ClickButton_JuQing)            --剧情
end

return Panel_WindowOnBelow