--商店的零件面板

local Panel_Shop_LingJianItem = require("ApplicationLayer/UI/Shop/Panel_Shop_LingJianItem")

local BaseUI = require("Framework/Base/BaseUI")
local Panel_Shop_LingJian = Class("Panel_Shop_LingJian",BaseUI)

Panel_Shop_LingJian.ClassifySelectButtons={}

function Panel_Shop_LingJian:On_Init(args)
    Panel_Shop_LingJian.putButtonPos = self.panel.transform:Find("ScrollView_DownCar/Viewport/Content")             --存放按钮的位置
    Panel_Shop_LingJian.selectButton = LoadManager.LoadGameObject("Panel_Shop_LingJianItem")           --需要被复制的按钮

    for k, v in pairs(DataManager.GetShopData().SLingJian) do
        LoadManager.CopyUI_WithParent( Panel_Shop_LingJian.selectButton, Panel_Shop_LingJian.putButtonPos, function(go, uitable)
            local createdButton = Panel_Shop_LingJianItem.New(go, uitable, v)
            Panel_Shop_LingJian.ClassifySelectButtons[v.showOrder] = createdButton
        end)
    end
end

function Panel_Shop_LingJian:Re_Show(args)
    self.canvas_group.alpha = 1

    for k, v in pairs(args) do
        if(  Panel_Shop_LingJian.ClassifySelectButtons[v.showOrder] ) then

        else
            LoadManager.CopyUI_WithParent( Panel_Shop_LingJian.selectButton, Panel_Shop_LingJian.putButtonPos, function(go, uitable)
                local createdButton = Panel_Shop_LingJianItem.New(go, uitable, v)
                Panel_Shop_LingJian.ClassifySelectButtons[v.showOrder] = createdButton
            end)
        end
    end
end

function Panel_Shop_LingJian:On_Hide()
    self.canvas_group.alpha = 0
end

return Panel_Shop_LingJian
