local Panel_Loading = Class("Panel_Loading", BaseUI)

local CG
local Rt

function Panel_Loading:On_Init(args)
    Rt = self.gameObject.transform:Find("Root")
    CG = self.CG
end

function Panel_Loading:On_Show()
    self.CG.alpha = 1
    Rt.anchoredPosition = Vector2(1200, 0)
    Rt:DOAnchorPos(Vector2(-200, 0), 1)

    self.uitable.ImagePro_Bg1. Rt.anchoredPosition = Vector2(-325, 0)
    self.uitable.ImagePro_Bg1. Rt:DOAnchorPos(Vector2(-866, 0), 1.2)

    self.uitable.ImagePro_Bg4. Rt.anchoredPosition = Vector2(220, 54)   --车的动画
    self.uitable.ImagePro_Bg4. Rt:DOAnchorPos(Vector2(-25, -67), 0.6)

    self.uitable.ImagePro_Bg5. Rt.anchoredPosition = Vector2(54, 8)
    self.uitable.ImagePro_Bg5. Rt:DOAnchorPos(Vector2(881, 8), 0.8)

    self.uitable.ImagePro_GuanJun. Rt.anchoredPosition = Vector2(700, 32.707)
    self.uitable.ImagePro_GuanJun. Rt:DOAnchorPos(Vector2(-41.5, 32.707), 1)
end

function Panel_Loading:On_Close()
    CG:DOFade(0, 0.3)
end

return Panel_Loading