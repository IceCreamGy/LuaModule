local UIManager = require "Framework/UIManager"       --ui管理类
local LoadManager = require("Framework/CS_Interface/LoadManager")
local UIEventHelper = require("Framework/CS_Interface/UIEventHelper")

--模拟一下服务器的数据
--Icon/headIcon_11  Icon/headIcon_12    Icon/headIcon_13


-- 进入游戏
function init()
    print("GameMain start...")

    playerInfo = {
        icon = "Icon/headIcon_11",
        name = "Kakara Asuka",
        level = "72"
    }

    UIManager.OpenUI("ApplicationLayer/UI/MainScene", playerInfo, function()
        print("打开 大厅面板")
    end)
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
