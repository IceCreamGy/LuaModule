--CShaper 与 LUA 的接口
LoadManager_InCS = require("Framework/CS_Interface/LoadManager")
TimerManager_InCS = require("Framework/CS_Interface/TimerManager")
NetworkManager_InCS = require("Framework/CS_Interface/NetworkManager_InCS")
LuaManager_InCS = require("Framework/CS_Interface/LuaManager")
--UIEventHelper = require("Framework/CS_Interface/UIEventHelper")

-- 一些工具变量，暂时放到这里，后期整理
require("Framework/Base/Class/Class")
BaseUI = require("Framework/Base/BaseUI")
Tools = require("Framework/Tools/Tools")
NetMsg = require("Framework/Config/NetMsg")
BundleConfig = require("Framework/Config/BundleConfig")
Event_InLua = require "Framework/Config/Event_InLua"
UnityEngine = CS.UnityEngine
Vector3 = UnityEngine.Vector3
Vector2 = UnityEngine.Vector2
Color = UnityEngine.Color
Quaternion = UnityEngine.Quaternion

--LUA端的管理器
UIManager = require("Framework/Manager_InLua/UIManager")
SceneManager = require("Framework/Manager_InLua/SceneManager")
DataManager = require("Framework/Manager_InLua/DataManager")
EventManager = require("Framework/Manager_InLua/EventManager")
NetworkManager = require("Framework/Manager_InLua/NetworkManager")
ProtobufManager = require("Framework/Manager_InLua/ProtobufManager")


-- 进入游戏
function init()
    print("GameMain start...")
    ProtobufManager.init()

    UIManager.OpenUI("Panel_Login", nil)           --登陆场景
    --UIManager.OpenUI("Panel_MainScene", nil)     --跳过登录场景

    local loginData = { name = "gaoyuan", age = 24, phone = "15210276982", password = "YGWH" }
    NetworkManager.Send(NetMsg.UserInfo, loginData)
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
