--商店模块

local selectButton = require("ApplicationLayer/UI/MainScene/Shop/Panel_Shop_ClassifySelectButton")

local Panel_Shop = Class("Panel_Shop", BaseUI)

local showContentArea = nil    --右边，实例化面板（推荐、零件）的位置

local ClassifySelectButtons = {}     --类别查看按钮
local putButtonPos = nil    --左边，实例化按钮的位置
local selectButtonGo = nil   --左边选择的按钮

function Panel_Shop:On_Init(args)
    self:LoadShopButtonItem()     --实例化左边选择的按钮
    self.uitable.TogglePro_ZhanGui:OnSelect()    --设置一个默认值
    EventManager.AddEvent(Event_InLua.ChangeShopRightPanel, Panel_Shop.OnChangeRightShow)
end

function Panel_Shop:LoadShopButtonItem()
    showContentArea = self.gameObject.transform:Find("ImagePro_Mask/Panel_ShowArea")     --存放展示面板的位置
    local toggles = {}
    toggles[1] = self.uitable.TogglePro_ZhanGui
    toggles[2] = self.uitable.TogglePro_S
    toggles[3] = self.uitable.TogglePro_A
    toggles[4] = self.uitable.TogglePro_BC
    toggles[5] = self.uitable.TogglePro_XHP

    --Lua排序
    table.sort(DataManager.GetShopData().ButtonList, function(a, b)
        return a.showOrder < b.showOrder
    end)

    for i, data in pairs(DataManager.GetShopData().ButtonList) do
        local createdButton = selectButton.New(toggles[i], data, showContentArea)
        ClassifySelectButtons[data.showOrder] = createdButton
    end
end

function Panel_Shop:On_Show()
    self.CG.alpha = 1
    self.uitable.ImagePro_Mask.Rt.sizeDelta = Vector2(0, 1080)
    self.uitable.ImagePro_Mask.Rt:DOSizeDelta(Vector2(1920, 1080), 0.4)
end

function Panel_Shop:On_Close()
    local tweenerBack = self.uitable.ImagePro_Mask.Rt:DOSizeDelta(Vector2(0, 1080), 0.4)
    tweenerBack:OnComplete(function()
        self.CG.alpha = 0
        EventManager.DispachEvent(Event_InLua.ReturnMain)
    end)
end

function Panel_Shop.OnChangeRightShow()
    showContentArea.localScale = Vector3(1, 0.8, 1)
    local tweenerBack = showContentArea:DOScale(1, 0.35)
    tweenerBack:SetEase(CS.DG.Tweening.Ease.OutBack)
end

return Panel_Shop
