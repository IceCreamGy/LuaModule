--商店模块

local selectButton = require("ApplicationLayer/UI/Shop/Panel_Shop_ClassifySelectButton")

local BaseUI = require("Framework/Base/BaseUI")
local Panel_Shop = Class("Panel_Shop", BaseUI)

Panel_Shop.showContentArea = nil    --右边，实例化面板（推荐、零件）的位置

local ClassifySelectButtons = {}     --类别查看按钮
local putButtonPos = nil    --左边，实例化按钮的位置
local selectButtonGo = nil   --左边选择的按钮

function Panel_Shop:On_Init(args)
    self.uitable.ImagePro_FromShopReturnToMain:AddClickListener(self.OnClick_Close)     --注册关闭事件
    self. showContentArea = self.panel.transform:Find("Panel_ShowArea")     --存放展示面板的位置
    self:LoadShopItem()

    --Panel_Shop.ClassifySelectButtons[0]:Select()        --设置一个默认值
    --Panel_Shop:OnSelectButton(Panel_Shop.ClassifySelectButtons[0])
end

function Panel_Shop:LoadShopItem()
    local buttonPath = BundleConfig.Get_UI("ImagePro_ShopSelectButtonItem")
    selectButtonGo = LoadManager.LoadGameObject(buttonPath)           --需要被复制的按钮
    putButtonPos = self.panel.transform:Find("ScrollView_ButtonSelect/Viewport/Content")             --存放按钮的位置

    --Lua排序
    table.sort(DataManager.GetShopData().ButtonList, function(a, b)
        return a.showOrder < b.showOrder
    end)

    --开始实例化
    for k, v in pairs(DataManager.GetShopData().ButtonList) do
        LoadManager.CopyUI_WithParent(selectButtonGo, putButtonPos, function(go, uitable)
            local createdButton = selectButton.New(go, uitable, v)
            ClassifySelectButtons[v.showOrder] = createdButton
        end)
    end
end

--当选择左边按钮时，
Panel_Shop.lastSelect = nil
function Panel_Shop:OnSelectButton(button)
    if (Panel_Shop.lastSelect) then
        if (Panel_Shop.lastSelect.data.type ~= button.data.type) then
            Panel_Shop.lastSelect:CancleSelect(true)
        else
            Panel_Shop.lastSelect:CancleSelect(false)
        end
    end

    button:Select()
    Panel_Shop. lastSelect = button
end

--当点击关闭
function Panel_Shop.OnClick_Close()
    UIManager.CloseUI()
end

function Panel_Shop:On_Show()
    self.CG.alpha = 1
end

function Panel_Shop:On_Close()
    self.CG.alpha = 0
end

return Panel_Shop
