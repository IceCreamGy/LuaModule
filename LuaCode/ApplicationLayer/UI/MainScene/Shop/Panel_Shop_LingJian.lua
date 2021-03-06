--商店的零件面板

local Panel_Shop_LingJianItem = require("ApplicationLayer/UI/MainScene/Shop/Panel_Shop_LingJianItem")

local Panel_Shop_LingJian = Class("Panel_Shop_LingJian", BaseUI)

local ClassifySelectButtons = {}  --对已经创建的按钮的持有

function Panel_Shop_LingJian:On_Init(args)
    self.uitable. Rt.anchoredPosition = Vector2(0, 0)

    Panel_Shop_LingJian.putButtonPos = self.gameObject.transform:Find("ScrollView_DownCar/Viewport/Content")             --存放按钮的位置
    local itemPath = BundleConfig.Get_UIAsset("Panel_Shop_LingJianItem")
    Panel_Shop_LingJian.selectButton = LoadManager_InCS.LoadGameObject(itemPath)           --需要被复制的按钮

    for k, v in pairs(DataManager.GetShopData():GetData(args)) do
        LoadManager_InCS.CopyUI_WithParent(Panel_Shop_LingJian.selectButton, Panel_Shop_LingJian.putButtonPos, function(go, uitable)
            local createdButton = Panel_Shop_LingJianItem.New(go, uitable, v)
            ClassifySelectButtons[v.showOrder] = createdButton
        end)
    end
end

function Panel_Shop_LingJian:On_Show(args)

    local data = DataManager.GetShopData():GetData(args)
    self.CG.alpha = 1

    if (data) then
        for k, v in pairs(data) do
            if (ClassifySelectButtons[v.showOrder]) then
                ClassifySelectButtons[v.showOrder]:Refresh(v)
            else
                LoadManager_InCS.CopyUI_WithParent(Panel_Shop_LingJian.selectButton, Panel_Shop_LingJian.putButtonPos, function(go, uitable)
                    local createdButton = Panel_Shop_LingJianItem.New(go, uitable, v)
                    ClassifySelectButtons[v.showOrder] = createdButton
                end)
            end
        end
    end
end

function Panel_Shop_LingJian:On_Close()
    self.CG.alpha = 0
    for i, v in pairs(ClassifySelectButtons) do
        v.gameObject:SetActive(false)
    end
end

return Panel_Shop_LingJian
