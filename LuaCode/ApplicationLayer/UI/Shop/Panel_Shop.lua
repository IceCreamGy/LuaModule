--商店模块

local selectButton = require("ApplicationLayer/UI/Shop/Panel_Shop_ClassifySelectButton")

local BaseUI = require("Framework/Base/BaseUI")
local Panel_Shop = Class("Panel_Shop", BaseUI)

Panel_Shop.ClassifySelectButtons = {}     --类别查看按钮

function Panel_Shop:On_Init(args)
    self.uitable.ImagePro_FromShopReturnToMain:AddClickListener(self.OnClick_Close)                             --注册关闭事件
    Panel_Shop.putButtonPos = self.panel.transform:Find("ScrollView_ButtonSelect/Viewport/Content")             --存放按钮的位置
    Panel_Shop.selectButton = LoadManager.LoadGameObject("ImagePro_ShopSelectButtonItem")           --需要被复制的按钮
    Panel_Shop.showContentArea = self.panel.transform:Find("Panel_ShowArea")                                    --存放展示面板的位置

    table.sort(DataManager.GetShopData().ButtonList, function(a, b)
        return a.showOrder < b.showOrder
    end)

    for k, v in pairs(DataManager.GetShopData().ButtonList) do
        LoadManager.CopyUI_WithParent(Panel_Shop.selectButton, Panel_Shop.putButtonPos, function(go, uitable)
            local createdButton = selectButton.New(go,uitable,v)
            Panel_Shop.ClassifySelectButtons[v.showOrder] = createdButton
        end)
    end
end

--当选择左边按钮时，
lastSelect = nil
function Panel_Shop:OnSelectButton(button)
    if (lastSelect) then
        if (lastSelect.data.type ~= button.data.type) then
            lastSelect:CancleSelect(true)
        else
            lastSelect:CancleSelect(false)
        end
    end

    button:Select()
    lastSelect = button
end

--当点击关闭
function Panel_Shop.OnClick_Close()
    UIManager.CloseUI()
end

function Panel_Shop:On_Show()
    --当打开时
    self.canvas_group.alpha = 1
end

function Panel_Shop:On_Close()
    --当关闭时
    self.canvas_group.alpha = 0
end

return Panel_Shop
