
local uimanager = require "Framework/UIManager"       --ui管理类

-- 进入游戏
function init()
    print("GameMain start...")

    --SceneManager:GetInstance():SwitchScene(SceneConfig.LoginScene)

    --Logger.Log("###################################################")
end

--c# update
function update()
    --eventmanager.dispach_lua_event(Lua_Event.Update)
end

--c# late update
function late_update()
    --eventmanager.dispach_lua_event(Lua_Event.LateUpdate)
end

-- 场景切换通知
local function OnLevelWasLoaded(level)

end

-- 退出App
local function OnApplicationQuit()

end
