--抽奖结果展示面板

local BaseUI = require("Framework/Base/BaseUI")
local Panel_LuckyResult = Class("Panel_LuckyResult", BaseUI)

--初始化
function Panel_LuckyResult:On_Init(args)
    self.uitable.ImagePro_Close:AddClickListener(self.OnClick_Close)
end

--当点击关闭
function Panel_LuckyResult.OnClick_Close()
    UIManager.CloseUI()
end

--当打开时
function Panel_LuckyResult:On_Show()
    self.CG.alpha = 1
    self.uitable.ImagePro_MaskArea.Rt.sizeDelta = Vector2(0, 520)
    self.uitable.ImagePro_MaskArea.Rt:DOSizeDelta(Vector2(1336, 750), 0.4)
end

--当关闭时
function Panel_LuckyResult:On_Close()
    self.tweenerClose = self.uitable.ImagePro_MaskArea.Rt:DOSizeDelta(Vector2(0, 750), 0.4)
    self.tweenerClose:OnComplete(function()                                                             --DoTween 动画事件回调
        self.CG.alpha = 0
    end)
end

return Panel_LuckyResult
