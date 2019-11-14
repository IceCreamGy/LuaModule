--分类选择按钮，就是面板左边那些按钮
--分别是，推荐展柜，S车零件，A车零件，B车C车零件，消耗品

local Panel_Shop_ClassifySelectButton = Class("Panel_Shop_ClassifySelectButton")

function Panel_Shop_ClassifySelectButton:ctor(GoParam, uitalbeParam, dataParam, lockPanelShowAreaParam)
    self.Go = GoParam
    self.uitable = uitalbeParam
    self.data = dataParam
    self.lockPanelShowArea = lockPanelShowAreaParam       --绑定的面板，实例化区域
    self.uitable.ImagePro_ButtonItem:SetImage(self.data.normalImage)                --初始化显示
    self.uitable.Text_Content.text = self.data.name                                 --初始化显
    self.lockdata = self.data.TargetData      --绑定的数据库名字

    --注册点击事件
    self.uitable.ImagePro_ButtonItem:AddClickListener(function()
        UIManager.GetPanel("Panel_Shop"):OnSelectButton(self)
    end)
end

--被选择
function Panel_Shop_ClassifySelectButton:Select()
    --改变自身按钮显示

    self.uitable.ImagePro_ButtonItem:SetImage(self.data.selectImage)
    self.uitable.Text_Content.color = Color.black
    -- self.PutPos = UIManager.GetPanel("Panel_Shop").showContentArea
    --弹出关联面板

    UIManager.OpenPoPupUI(self.data.TargetModel, self.lockdata, self. lockPanelShowArea)
    --记录关联面板
    self.lockPanel = UIManager.GetPanel(self.data.TargetModel)
end

--取消选择
function Panel_Shop_ClassifySelectButton:CancleSelect(closeBg)
    --CloseBg  是否关闭底板

    self.uitable.ImagePro_ButtonItem:SetImage(self.data.normalImage)         --按钮更改底图
    self.uitable.Text_Content.color = Color.white                            --按钮更改文字颜色

    if (self.lockPanel and closeBg) then
        self.lockPanel:Close()                                                --关联的展示面板隐藏
    end
end

return Panel_Shop_ClassifySelectButton