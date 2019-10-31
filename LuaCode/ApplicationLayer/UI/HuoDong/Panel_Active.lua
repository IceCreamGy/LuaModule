--活动总面板 控制逻辑
local BaseUI = require("Framework/Base/BaseUI")
local Panel_Active = Class("Panel_Active", BaseUI)
local buttonItem = require("ApplicationLayer/UI/HuoDong/Panel_Active_ButtonItem")

Panel_Active.buttonGoResource = nil
Panel_Active.selectButtonContainer = nil
Panel_Active.Buttons = {}

function Panel_Active:On_Init(args)
    self.buttonGoResource = LoadManager.LoadGameObject("ImagePro_ButtonItem")    --加载出来的Button （暂未实例化
    self.selectButtonContainer = self.uitable.ScrollRect_SelectButton.content     --存放按钮的父物体 Trans

    index = 0
    for k, v in pairs(args) do              --初始化所有按钮
        LoadManager.CopyUI_WithParent(self.buttonGoResource, self.selectButtonContainer, function(Go, uitable)
            Go.name = k     --改物体的名字，方便编辑器下查看
            local HasCreaterButtonItem = buttonItem.New(Go, uitable, v)
            Panel_Active.Buttons[k] = HasCreaterButtonItem
        end)

        if (index == 0) then                        --默认选择第一个活动
            Panel_Active.Buttons[k]:Select()
        end
        index = index + 1
    end

    self.uitable.ImagePro_ReturnButton:AddClickListener(self.OnClick_Close)
end

function Panel_Active:OnClick_Close()
    UIManager.CloseUI()
end

lastSelect = nil
function Panel_Active:OnSelectButton(button)
    if (lastSelect) then
        lastSelect:CancleSelect()
    end
    lastSelect = button
end

function Panel_Active:On_Show()
    --当打开时
    self.canvas_group:DOFade(1, 0.6)
end

function Panel_Active:On_Close()
    --当关闭时
    self.canvas_group:DOFade(0, 0.6)
end

return Panel_Active