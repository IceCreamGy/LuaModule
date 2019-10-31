--常用事件
--Button
--PopList
--ScrollView

local CS_UIEventHelper = CS.UIEventHelper

--设置按钮事件   Button  Button对象，Function 回调
function SetButtonClick(button, func)
    CS_UIEventHelper.SetButtonClick(button, func)
end

--设置GameObject的激活与否
function SetGoSetActive(GameObject, path, state)
    CS_UIEventHelper.SetGoSetActive(GameObject, path, state)
end