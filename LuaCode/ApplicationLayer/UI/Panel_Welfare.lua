--新手福利面板

local BaseUI = require("Framework/Base/BaseUI")
local Panel_Welfare = Class("Panel_Welfare", BaseUI)

function Panel_Welfare:On_Init(args)
    --初始化
    self.uitable.ImagePro_Close:AddClickListener(self.OnClick_Close)
end

function Panel_Welfare.OnClick_Close()
    --当点击关闭
    UIManager.CloseUI()
end

tweener = nil
function Panel_Welfare:On_Show()
    --当打开时

    self.canvas_group.alpha = 1
    self.uitable.ImagePro_Bg.Rt.anchoredPosition = Vector2(-1800, 0)
    tweener = self.uitable.ImagePro_Bg.Rt:DOAnchorPos(Vector2(0, 0), 1)
    tweener:SetAutoKill(false)
end

function Panel_Welfare:On_Close()
    --当关闭时
    self.canvas_group:DOFade(0, 1)
    tweener:PlayBackwards()             --DoTween 的反向使用
end

return Panel_Welfare
