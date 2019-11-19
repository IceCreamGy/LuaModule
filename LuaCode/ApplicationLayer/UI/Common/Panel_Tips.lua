--提示面板

local Panel_Tips = Class("Panel_Tips", BaseUI)

local function OnClick_Close()
    UIManager.CloseTarget("Panel_Tips")
end

--注意参数一定要Table ，后期可能还会传入 确定，取消 等事件回调。
--Content OkAction  CancleAction
function Panel_Tips:On_Init(args)
    self.uitable.ImagePro_Close:AddClickListener(OnClick_Close)
end

function Panel_Tips:On_Show(args)
    self.uitable.Text_Content.text= args.content
    self.CG.alpha = 1
    self.uitable.ImagePro_Bg.Rt.localScale =Vector3(0.3,0.3,0.3)
    self.uitable.ImagePro_Bg.Rt:DOScale(1,0.4)
end
function Panel_Tips:On_Close()
    self.uitable.ImagePro_Bg.Rt:DOScale(0,0.45)
    self.CG:DOFade(0,0.45)
end

return Panel_Tips

