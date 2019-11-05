--商店的展柜模块

local ShopData = require("ApplicationLayer/DataCenter/ShopData")        --商店数据
local selectButton = require("ApplicationLayer/UI/Shop/Panel_Shop_ClassifySelectButton")

local BaseUI = require("Framework/Base/BaseUI")
local Panel_Shop_ZhanGui = Class("Panel_Shop_ZhanGui", BaseUI)

function Panel_Shop_ZhanGui:On_Init(args)

end

function Panel_Shop_ZhanGui:On_Show()
    self.CG.alpha = 1
end

function Panel_Shop_ZhanGui:On_Close()
    self.CG.alpha = 0
end

return Panel_Shop_ZhanGui
