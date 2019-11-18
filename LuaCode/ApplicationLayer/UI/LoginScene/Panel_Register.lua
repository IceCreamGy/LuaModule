--注册面板

local Panel_Register = Class("Panel_Register", BaseUI)

local uiItem = {}  --InputName InputPassword  LoginButton 仅仅做一些动画
local recordPos = {}
local inputName, inputPassword, inputPassword2

--初始化组件的引用，动画
local function InitUiItem(self)
    inputName = self.uitable.InputField_Name
    inputPassword = self.uitable.InputField_Password
    inputPassword2 = self.uitable.InputField_Password2

    uiItem[1] = self.uitable.ImagePro_RegisterName
    uiItem[2] = self.uitable.ImagePro_RegisterPassword
    uiItem[3] = self.uitable.ImagePro_RegisterPassword2
    uiItem[4] = self.uitable.ImagePro_Register
    for i, v in ipairs(uiItem) do
        v.gameObject:SetActive(false)
        v.CG.alpha = 0
        recordPos[i] = v.Rt.anchoredPosition
        v.Rt.anchoredPosition = Vector2(recordPos[i].x + 100, recordPos[i].y)
    end
end

local index = 1
local function OpenUI()
    --动画依次打开
    uiItem[index].gameObject:SetActive(true)
    uiItem[index].CG:DOFade(1, 0.4)
    uiItem[index].Rt:DOAnchorPos(recordPos[index], 0.4)

    index = index + 1
    if (index <= #uiItem) then
        TimerManager_InCS.Add(0.3, 1, OpenUI)
    end
end

local function SendData()
    local registerData = {
        name = inputName.text,
        password = inputPassword.text,
    }
    NetworkManager.Send(NetMsg.UserRegister, registerData)
    UIManager.CloseUI()
end

function Panel_Register:On_Init(args)
    self.uitable.ImagePro_Register:AddClickListener(SendData)
    InitUiItem(self)
    TimerManager_InCS.Add(0.4, 1, OpenUI)
end

function Panel_Register:On_Show()
    self.CG.alpha = 1
end
function Panel_Register:On_Close()
    self.CG.alpha = 0
end

return Panel_Register

