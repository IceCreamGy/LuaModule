
local BaseUI = require("Framework/Base/BaseUI")
local Panel_JuQing = Class("Panel_JuQing",BaseUI)

local function OnClick_Close()
    UIManager.CloseUI()
end

function Panel_JuQing:On_Init(args)
    self.uitable.ImagePro_ReturnToMain:AddClickListener(OnClick_Close)
end

function Panel_JuQing:On_Show()
    self.CG.alpha = 1
    self.uitable.ImagePro_Mask.Rt.sizeDelta = Vector2(0, 1080)
    self.uitable.ImagePro_Mask.Rt:DOSizeDelta(Vector2(1920, 1080), 0.4)
end
function Panel_JuQing:On_Close()
    local tweenerBack = self.uitable.ImagePro_Mask.Rt:DOSizeDelta(Vector2(0, 1080), 0.4)
    tweenerBack:OnComplete(function()
        self.CG.alpha = 0
        EventManager.DispachEvent(Event_InLua.ReturnMain)
    end)
end

return Panel_JuQing