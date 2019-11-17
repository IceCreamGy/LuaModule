EventManager = require "Framework/EventManager"
Event_InLua = require "Framework/Config/Event_InLua"
UIManager = require "Framework/UIManager"       --ui管理类
LoadManager = require("Framework/CS_Interface/LoadManager")
SceneManager = require("Framework/SceneManager")
TimerManager = require("Framework/CS_Interface/TimerManager")
UIEventHelper = require("Framework/CS_Interface/UIEventHelper")
DataManager = require("ApplicationLayer/DataCenter/DataManager")
BundleConfig = require("Framework/Config/BundleConfig")
Tools = require("Framework/Tools/Tools")
NetworkManager = require "Framework/NetworkManager"
NetworkManager_InCS = require "Framework/CS_Interface/NetworkManager_InCS"
LuaManager = require "Framework/CS_Interface/LuaManager"
NetMsg = require("Framework/Config/NetMsg")
ProtobufManager = require"Framework/ProtobufManager"

--暂时放到这里，后期整理
UnityEngine = CS.UnityEngine
Vector3 = UnityEngine.Vector3
Vector2 = UnityEngine.Vector2
Color = UnityEngine.Color
Quaternion = UnityEngine.Quaternion

-- 进入游戏
function init()
    print("GameMain start...")
    ProtobufManager.init()

    UIManager.OpenUI("Panel_Login", nil)           --登陆场景
    --UIManager.OpenUI("Panel_MainScene", nil)     --跳过登录场景

    NetworkManager.Send(NetMsg.UserInfo, { name = "gaoyuan", level = 10, diamond = 500 })
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
