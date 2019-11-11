--主面板左边的一些按钮
--排行榜，仓库，活动，邮件，考场，签到

local BaseUI = require("Framework/Base/BaseUI")
local Panel_WindowOnLeft = Class("Panel_WindowOnLeft", BaseUI)

local buttons = {}
--打开签到
local function ClickButton_QianDao()
    UIManager.OpenUI("ApplicationLayer/UI/QianDao/Panel_QianDao", nil)
end

function Panel_WindowOnLeft:Init(args)
    local function AddButtonAnimation()
        buttons[1] = self.uitable.ImagePro_PaiHangBang
        buttons[2] = self.uitable.ImagePro_CangKu
        buttons[3] = self.uitable.ImagePro_HuoDong
        buttons[4] = self.uitable.ImagePro_YouJian
        buttons[5] = self.uitable.ImagePro_KaoChang
        buttons[6] = self.uitable.ImagePro_QianDao

        for i, v in ipairs(buttons) do
            buttons[i].CG.alpha = 0
            buttons[i].CG:DOFade(1, 0.6)
            buttons[i].Rt.localScale = Vector3(1.3, 1.3, 1.3)
            buttons[i].Rt:DOScale(1, 0.4)
        end
    end
    AddButtonAnimation()

    self.uitable.Rt.anchoredPosition = Vector2(175, 0);
    self.uitable.ImagePro_QianDao:AddClickListener(ClickButton_QianDao)
end

return Panel_WindowOnLeft