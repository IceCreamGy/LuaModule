--登录面板

local BaseUI = require("Framework/Base/BaseUI")
local Panel_Login = Class("Panel_Login", BaseUI)

local function EnterToMain()
    UIManager.CloseTarget("Panel_Loading")
    UIManager.OpenUI("ApplicationLayer/UI/MainScene/Main/Panel_MainScene", nil)
end

local function LoadMainScene()
    SceneManager.LoadScene("Scene_Garage03", EnterToMain)
end

local uiItem = {}  --InputName InputPassword  LoginButton 仅仅做一些动画
local recordPos={}
local function InitUiItem(self)
    uiItem[1] = self.uitable.ImagePro_Name
    uiItem[2] = self.uitable.ImagePro_Password
    uiItem[3] = self.uitable.ImagePro_Login
    for i, v in ipairs(uiItem) do
        v.gameObject:SetActive(false)
        v.CG.alpha=0
        recordPos[i]= v.Rt.anchoredPosition
        v.Rt.anchoredPosition=Vector2( recordPos[i].x+100, recordPos[i].y)
    end
end

local index = 1
local function OpenUI()
    --动画依次打开
    uiItem[index].gameObject:SetActive(true)
    uiItem[index].CG:DOFade(1,0.4)
    uiItem[index].Rt:DOAnchorPos(recordPos[index], 0.4)

    index = index + 1
    if (index <= #uiItem) then
        TimerManager.Add(0.3, 1, OpenUI)
    end
end

function Panel_Login:On_Init(args)
    self.uitable.ImagePro_Login:AddClickListener(LoadMainScene)
    InitUiItem(self)
    TimerManager.Add(0.4, 1, OpenUI)
end

function Panel_Login:On_Show()
    self.uitable.ImagePro_Bg.Rt.localScale = Vector3(1.3, 1.3, 1.3)
    self.uitable.ImagePro_Bg.Rt:DOScale(1, 0.4)
end
function Panel_Login:On_Close()
    self.uitable.Rt:DOAnchorPos(Vector2(-2400, 0), 0.6)
end
return Panel_Login