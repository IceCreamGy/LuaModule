--商店的展柜模块

local BaseUI = require("Framework/Base/BaseUI")
local Panel_Shop_ZhanGui = Class("Panel_Shop_ZhanGui", BaseUI)

function Panel_Shop_ZhanGui:On_Init(args)
    self.uitable. Rt.anchoredPosition = Vector2(0, 0)
end

function Panel_Shop_ZhanGui:On_Show()
    self.CG.alpha = 1
end

function Panel_Shop_ZhanGui:On_Close()
    self.CG.alpha = 0
end

return Panel_Shop_ZhanGui
