--零件模块。
--商店里展示的物品

local Panel_Shop_LingJianItem = Class("Panel_Shop_LingJianItem")

function Panel_Shop_LingJianItem:ctor(GoParam, uitableParam, dataParam)
    self.Go = GoParam
    self.uitable = uitableParam
    self.data = dataParam
    self.uitable.Text_CarName.text = self.data.name                     --初始化名字显示

    self.uitable.ImagePro_Car:SetImage(self.data.icon)                  --初始化商品图片
    self.uitable.Text_Money.text=self.data.moneyCount                   --初始化商品价格

    --注册点击事件
    self.uitable.ImagePro_DownCarItem:AddClickListener(function()
        --弹出购买确认面板
        --UIManager.OpenPoPupUI
    end)
end

function Panel_Shop_LingJianItem:Refresh(data)
    self.uitable.Text_CarName.text = data.name                     --初始化名字显示
    self.uitable.ImagePro_Car:SetImage(data.icon)                  --初始化商品图片
    self.uitable.Text_Money.text=data.moneyCount                   --初始化商品价格
end

function Panel_Shop_LingJianItem:Hide()
    --self.Go 开

end
function Panel_Shop_LingJianItem:Show()
    --self.Go 关
end

return Panel_Shop_LingJianItem