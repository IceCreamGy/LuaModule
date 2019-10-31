--选择按钮

local Panel_Active_ButtonItem = Class("Panel_Active_ButtonItem")

function Panel_Active_ButtonItem:ctor(GoParam, uitalbeParam, dataParam)
    self.Go = GoParam
    self.uitable = uitalbeParam
    self.data = dataParam
    self.uitable.ImagePro_ButtonItem:SetImage(self.data.ImageNormal)                --初始化显示
    self.uitable.ImagePro_ButtonItem:AddClickListener(function()                    --注册点击事件
        self.uitable.ImagePro_ButtonItem:SetImage(self.data.ImageSelect)
        local PutPos = nil    --加载出来的活动面板，放置位置
        PutPos = CS.UnityEngine.GameObject.Find("Panel_Active(Clone)").transform:Find("ContentShowArea")
        UIManager.OpenPoPupUIWithParent(self.data.TargetModel,  PutPos,nil)
        Panel_Active:OnSelectButton(self)
    end)
end

--被选择
function Panel_Active_ButtonItem:Select()
    self.uitable.ImagePro_ButtonItem:SetImage(self.data.ImageSelect)

    local PutPos = nil    --加载出来的活动面板，放置位置
    PutPos = CS.UnityEngine.GameObject.Find("Panel_Active(Clone)").transform:Find("ContentShowArea")
    UIManager.OpenPoPupUIWithParent(self.data.TargetModel,  PutPos,nil)

    Panel_Active:OnSelectButton(self)
end

--取消选择
function Panel_Active_ButtonItem:CancleSelect()
    self.uitable.ImagePro_ButtonItem:SetImage(self.data.ImageNormal)
end

--[[function Panel_Active_ButtonItem:OnSelect()
    self.uitable.ImagePro_ButtonItem:SetImage(self.data .ImageSelect)
end]]

return Panel_Active_ButtonItem