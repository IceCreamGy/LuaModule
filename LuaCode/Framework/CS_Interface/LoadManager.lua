--从Unity中加载资源、对象

--真正的加载，在C#端实现
local CS_LoadManager = CS.AppFacade.instance:GetLoadManager()

local LoadManager = {}

--加载UI
function LoadManager.LoadUI(layer, bundleName, func, parent)
    CS_LoadManager:LoadUI(layer, bundleName, func, parent)
end

--复制UI，并设置父物体
function LoadManager.CopyUI_WithParent(gameobject, parent, func)
    return CS_LoadManager:CopyUI_WithParent(gameobject, parent, func)
end

--加载Texture
function LoadManager.LoadTexture(bundleName, func)
    CS_LoadManager:LoadTexture(bundleName, func)
end

--加载Sprite
function LoadManager.LoadSprite(bundleName, func)
    CS_LoadManager:LoadSprite(bundleName, func)
end

--加载GameObject
function LoadManager.LoadGameObject(bundleName)
    return CS_LoadManager:LoadGameObject(bundleName)
end

--复制GameObject
function LoadManager.CopyGameobject(bundleName)
    return CS_LoadManager:CopyGameobject(bundleName)
end

function LoadManager.LoadScene(SceneName, EndAction)
    CS_LoadManager:LoadScene(SceneName, EndAction)
end

--[[

--/////////////////////////////////////////////////////////////////////
--TODO：Lua启动时触发
-- 设置常驻包
-- 任何情况下不想被卸载的非公共包（Shader Font）需要手动设置常驻包
local function LoadManager_LoadPersisdentRes(bundleName)
    CS_LoadManager:LoadPersisdentRes(bundleName)
end

--/////////////////////////////////////////////////////////////////////
--TODO：常用资源加载

--加载 UI func(参数1 gameobject（panel物体）  参数2 luatable（存放空间的hash） 参数3 canvasgroup (控制显隐）)
local function LoadManager_LoadUI(bundleName, func)
    CS_LoadManager:LoadUI(bundleName, func)
end

--加载 场景,func（无参）是加载完成后的回调
local function LoadManager_LoadScene(bundleName, sceneProgressAction, endAction)
    CS_LoadManager:LoadScene(bundleName, sceneProgressAction, endAction)
end

--加载 角色,func（参数1 xx , 参数2 xx,参数3 xx）是加载完成后的回调
local function LoadManager_LoadCharacter(prefab_bundleName, avatar_bundleName, avatar_name, func)
    CS_LoadManager:LoadCharacter(prefab_bundleName, avatar_bundleName, avatar_name, func)
end

--加载 车
local function LoadManager_LoadCar(bundleName, assetName, func)
    CS_LoadManager:LoadCharacter(bundleName, assetName, func)
end

--//////////////////////////////////////////////////////////////
--TODO：对象池相关的调用

--加载 游戏物体,func（参数1 Gameobject,参数2 是加载完成后的回调）
local function LoadManager_LoadGameobject(bundleName, func)
    CS_LoadManager:LoadGameobject(bundleName, func)
end

--复制 游戏物体
local function LoadManager_CopyGameobject(gameobject)
    return CS_LoadManager:CopyGameobject(gameobject)
end

--移除 游戏物体
local function LoadManager_DestroyGameobject(gameobject)
    CS_LoadManager:DestroyGameobject(gameobject)
end

--//////////////////////////////////////////////////////////////
--TODO：其他功能

-- 是否有加载任务正在进行
local function IsProsessRunning(self)

end

-- 清理资源：切换场景时调用
local function Cleanup(self)
    --AssetBundleManager:ClearAssetsCache()
    --AssetBundleManager:UnloadAllUnusedResidentAssetBundles()
end
]]

return LoadManager