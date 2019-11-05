UIManager = require "Framework/UIManager"       --ui管理类
LoadManager = require("Framework/CS_Interface/LoadManager")
UIEventHelper = require("Framework/CS_Interface/UIEventHelper")
DataManager = require("ApplicationLayer/DataCenter/DataManager")

--暂时放到这里，后期整理
UnityEngine = CS.UnityEngine
Vector3 = UnityEngine.Vector3
Vector2 = UnityEngine.Vector2
Color = UnityEngine.Color

-- 进入游戏
function init()
    print("GameMain start...")

    UIManager.OpenUI("ApplicationLayer/UI/Panel_MainScene",nil)
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
