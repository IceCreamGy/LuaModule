--分类选择按钮，就是面板左边那些按钮
--分别是，推荐展柜，S车零件，A车零件，B车C车零件，消耗品

local Panel_Shop_ClassifySelectButton = Class("Panel_Shop_ClassifySelectButton")

function Panel_Shop_ClassifySelectButton:ctor(toggle, dataParam, lockPanelShowAreaParam)
    local function Select()
        toggle.Text_lable.color = Color.black
        --弹出关联面板
        UIManager.OpenPoPupUI(dataParam.TargetModel, dataParam.TargetData, lockPanelShowAreaParam)
        --记录关联面板
        self.lockPanel = UIManager.GetPanel(dataParam.TargetModel)
        --UIManager.GetPanel("Panel_Shop"):OnSelectButton(self)
    end
    local function CancleSelect()
        toggle.Text_lable.color = Color.white
        if (self.lockPanel) then
            self.lockPanel:Close()                                                --关联的展示面板隐藏
        end
    end
    --注册点击事件
    toggle:AddEvent(Select, CancleSelect)
end

return Panel_Shop_ClassifySelectButton