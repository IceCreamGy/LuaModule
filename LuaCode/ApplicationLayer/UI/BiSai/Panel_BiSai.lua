--比赛选择
--竞速匹配
--对战大厅

local BaseUI = require("Framework/Base/BaseUI")
local Panel_BiSai = Class("Panel_BiSai", BaseUI)

function Panel_BiSai:On_Init(args)
    self.uitable.ImagePro_ReturnToMain:AddClickListener(self.OnClick_Close)
end

function Panel_BiSai:OnClick_Close()
    UIManager.CloseUI()
end

function Panel_BiSai:On_Show()
    self:On_Re_Show()
end

function Panel_BiSai:On_Re_Show()
    self.uitable.ImagePro_PiPei.Rt.anchoredPosition = Vector2(-1314, 0)     --两个按钮的位置
    self.uitable.ImagePro_PiPei.Rt:DOAnchorPos(Vector2(0, 0), 0.3)
    self.uitable.ImagePro_DaTing.Rt.anchoredPosition = Vector2(1314, 0)
    self.uitable.ImagePro_DaTing.Rt:DOAnchorPos(Vector2(0, 0), 0.3)
    self.canvas_group.alpha = 1                                             --底图的透明度
    self.uitable.ImagePro_BiSaiBg.Cg.alpha = 0
    self.uitable.ImagePro_BiSaiBg.Cg:DOFade(1, 0.35)
end

function Panel_BiSai:On_Close()
    self.uitable.ImagePro_BiSaiBg.Cg:DOFade(0, 0.5)         --地图透明度
    self.uitable.ImagePro_DaTing.Rt:DOAnchorPos(Vector2(1314, 0), 0.3)      --按钮的位置
    Panel_BiSai.CloseTweener = self.uitable.ImagePro_PiPei.Rt:DOAnchorPos(Vector2(-1314, 0), 0.3)
    Panel_BiSai.CloseTweener:OnComplete(function()      --位移动画完成后，关闭所有面板
        self.canvas_group.alpha = 0
    end)
end

return Panel_BiSai