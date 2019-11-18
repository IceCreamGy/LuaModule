--抽奖结果展示面板

local Panel_BuJiResult = Class("Panel_BuJiResult", BaseUI)

--初始化
function Panel_BuJiResult:On_Init(args)
    self.uitable.ImagePro_Close:AddClickListener(self.OnClick_Close)
end

--当点击关闭
function Panel_BuJiResult.OnClick_Close()
    UIManager.CloseUI()
end

--当打开时
function Panel_BuJiResult:On_Show()
    self.CG.alpha = 1
    self.uitable.ImagePro_MaskArea.Rt.sizeDelta = Vector2(0, 520)
    self.uitable.ImagePro_MaskArea.Rt:DOSizeDelta(Vector2(1336, 750), 0.4)
end

--当关闭时
function Panel_BuJiResult:On_Close()
    self.tweenerClose = self.uitable.ImagePro_MaskArea.Rt:DOSizeDelta(Vector2(0, 750), 0.4)
    self.tweenerClose:OnComplete(function()                                                             --DoTween 动画事件回调
        self.CG.alpha = 0
    end)
end

return Panel_BuJiResult
