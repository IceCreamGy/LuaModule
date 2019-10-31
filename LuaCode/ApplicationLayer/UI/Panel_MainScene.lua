--主场景初始面板（大厅）
local BaseUI = require("Framework/Base/BaseUI")
local Panel_MainScene = Class("Panel_MainScene",BaseUI)

--暂存变量
local GameObjectPanel

function Panel_MainScene:On_Init(args)
    GameObjectPanel = self.panel

    self.uitable.ImagePro_OpenShop:AddClickListener(self.ClickButton_OpenShop)        --商店
    self.uitable.ImagePro_QianDao:AddClickListener(self.ClickButton_QianDao)          --签到
    self.uitable.ImagePro_OpenSupply:AddClickListener(self.ClickButton_OpenSupply)    --码头
    self.uitable.ImagePro_HuoDong:AddClickListener(self.ClickButton_HuoDong)          --活动
    --初始化 数据
    self:InitData(args)
    --初始化 按钮动画
    self:InitButton()
end

--初始化 数据
function Panel_MainScene:InitData(args)
    self.uitable.Text_Name.text = args.name               --改 Text
    self.uitable.Text_Level.text = args.level
    self.uitable.Image_PlayerIcon:SetImage(args.icon)       --改 Image
end

--打开商店
function Panel_MainScene:ClickButton_OpenShop()
    UIManager.OpenUI("ApplicationLayer/UI/Shop/Panel_Shop", nil)
end

--打开补给码头
function Panel_MainScene:ClickButton_OpenSupply()
    UIManager.OpenUI("ApplicationLayer/UI/Panel_Lucky", nil)
end

--打开签到
function Panel_MainScene:ClickButton_QianDao()
    UIManager.OpenUI("ApplicationLayer/UI/Panel_Welfare", nil)
end

--打开活动
function Panel_MainScene:ClickButton_HuoDong()
    UIManager.OpenUI("ApplicationLayer/UI/HuoDong/Panel_Active", DataManager.GetActiveData())
end

--初始化 按钮动画
function Panel_MainScene:InitButton()
    SystemButtons = {}    --系统按钮集合
    SystemButtonsInitPosition = {}    --系统按钮的初始化位置，

    --暂存需要处理的按钮
    SystemButtons[1] = self.uitable.ImagePro_OpenShop         --商城
    SystemButtons[2] = self.uitable.ImagePro_OpenSupply       --码头
    SystemButtons[3] = self.uitable.ImagePro_OpenRace         --赛事
    SystemButtons[4] = self.uitable.ImagePro_OpenPVP          --PVP
    SystemButtons[5] = self.uitable.ImagePro_OpenPVE          --PVE

    for i = 1, #SystemButtons do
        SystemButtonsInitPosition[i] = SystemButtons[i].Rt.anchoredPosition         --记录按钮的位置
        SystemButtons[i].Rt.anchoredPosition = Vector2(3000, -35)                   --修改位置
        SystemButtons[i].Rt:DOAnchorPos(SystemButtonsInitPosition[i], 0.5)          --DoTween 位置动画
        SystemButtons[i].Cg.alpha = 0.2                                             --修改透明度
        SystemButtons[i].Cg:DOFade(1, 0.5)                                            --DoTween 透明度动画
    end
end

return Panel_MainScene
