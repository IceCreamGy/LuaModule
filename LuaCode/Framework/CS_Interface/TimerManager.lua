--时间回调器

local CS_TimeManager = CS.AppFacade.instance:GetTimerManager()

local TimerManager = {}

function TimerManager.Add(interval, repeatCount, timeCallback, timeParam)
    CS_TimeManager:Add(interval, repeatCount, timeCallback, timeParam)
end

return TimerManager