--主面板上方的一些按钮
--玩家信息，金币，点券，石油，车库，设置，wifi

local BaseUI = require("Framework/Base/BaseUI")
local Panel_WindowOnUp = Class("Panel_WindowOnUp", BaseUI)

local buttons = {}
local buttonsDoScale={}
local AnchoredPosition = {}

function Panel_WindowOnUp:Init(args)
    local function AddButtonAnimation()
        buttons[1] = self.uitable.ImagePro_BgPlayerInfoBg         --玩家信息
        buttons[2] = self.uitable.ImagePro_BgNon       --暂无
        buttons[3] = self.uitable.ImagePro_BgJinBi         --金币
        buttons[4] = self.uitable.ImagePro_BgDianJuan          --点券
        buttons[5] = self.uitable.ImagePro_BgShiYou          --石油
        buttons[6] = self.uitable.ImagePro_CheKu          --车库
        buttons[7] = self.uitable.ImagePro_System          --系统
        buttons[8] = self.uitable.ImagePro_Wifi          --wifi

        buttonsDoScale[1] = self.uitable.ImagePro_LogoJinBi         --金币
        buttonsDoScale[2] = self.uitable.ImagePro_LogoDianQuan          --点券
        buttonsDoScale[3] = self.uitable.ImagePro_LogoShiYou          --石油

        for i, v in ipairs(buttons) do
            v.CG.alpha = 0
            v.CG:DOFade(1, 0.3)

            AnchoredPosition[i] = v.Rt.anchoredPosition         --记录按钮的位置
            v.Rt.anchoredPosition = Vector2(AnchoredPosition[i].x, 100)                   --修改位置
            v.Rt:DOAnchorPos(AnchoredPosition[i], 1- i*0.13)          --DoTween 位置动画
        end
    end
    AddButtonAnimation()

    self.uitable.Rt.anchoredPosition = Vector2(0, 0);

    local data = DataManager.GetPlayerInfo()
    --初始化 数据
    self:InitData(data)

    --self.uitable.ImagePro_OpenShop:AddClickListener(ClickButton_OpenShop)        --商店
end

--初始化 数据
function Panel_WindowOnUp:InitData(args)
    self.uitable.Text_Name.text = args.name               --改 Text
    self.uitable.Text_Level.text = args.level
    self.uitable.Image_PlayerIcon:SetImage(args.icon)       --改 Image
end

return Panel_WindowOnUp