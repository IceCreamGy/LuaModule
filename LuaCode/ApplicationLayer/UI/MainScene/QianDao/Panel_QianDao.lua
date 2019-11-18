--签到面板

local Panel_QianDao = Class("Panel_QianDao", BaseUI)

local toggles = {}
local function InitToggles(self)
    toggles[1] = self.uitable.TogglePro_1
    toggles[2] = self.uitable.TogglePro_2
    toggles[3] = self.uitable.TogglePro_3
    toggles[4] = self.uitable.TogglePro_4
    toggles[5] = self.uitable.TogglePro_5
    toggles[6] = self.uitable.TogglePro_6
    toggles[7] = self.uitable.TogglePro_7
end
local function BgDiBan(self)
    self.uitable.ImagePro_Bg.fillAmount = 0.1
    self.uitable.ImagePro_Bg:DOFillAmount(1, 0.4);

    self.uitable.ImagePro_BgFont.CG.alpha = 0
    self.uitable.ImagePro_BgCar.CG.alpha = 0

    for i, v in ipairs(toggles) do
        v.gameObject:SetActive(false)
    end
end

function Panel_QianDao:On_Init(args)
    self.uitable.Rt.anchoredPosition = Vector2(0, 0)
    InitToggles(self)   --初始化Toogles
    self.uitable.ImagePro_Close:AddClickListener(self.OnClick_Close)
end

function Panel_QianDao:On_Show()
    self.CG:DOFade(1, 0.6)
    BgDiBan(self)      --底板动画
    TimerManager_InCS.Add(0.15, 1, Panel_QianDao.BgAnimation, self)      --底板动画2
    TimerManager_InCS.Add(0.3, 1, Panel_QianDao.ShowToggles)        --Toggle组动画
end

--上方Logo字体动画，下方汽车插图动画
function Panel_QianDao.BgAnimation(self)
    --文字的动画
    self.uitable.ImagePro_BgFont.CG.alpha = 1
    self.uitable.ImagePro_BgFont.Rt.anchoredPosition = Vector2(-603.2, -120)
    self.uitable.ImagePro_BgFont.Rt:DOAnchorPos(Vector2(25.7, -12), 0.25)
    --汽车的动画
    self.uitable.ImagePro_BgCar.CG.alpha = 1
    self.uitable.ImagePro_BgCar.Rt.anchoredPosition = Vector2(60, 308)
    self.uitable.ImagePro_BgCar.Rt:DOAnchorPos(Vector2(-348, 209), 0.25)
end
--可以点击的Toggle动画
function Panel_QianDao.ShowToggles()
    for i, v in ipairs(toggles) do
        v.gameObject:SetActive(true)
        v.CG.alpha = 0
        v.CG:DOFade(1, 0.4)
        v.RT.localScale = Vector3(1.2, 1.2, 1.2)
        v.RT:DOScale(1, 0.25)
    end
end

function Panel_QianDao.OnClick_Close()
    UIManager.CloseUI()
end
function Panel_QianDao:On_Close()
    self.CG:DOFade(0, 0.3)
end

return Panel_QianDao
