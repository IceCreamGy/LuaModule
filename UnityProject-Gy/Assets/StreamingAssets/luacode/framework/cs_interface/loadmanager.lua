--从Unity中加载资源、对象
--Lua启动时触发
----常用资源加载
----对象池相关的调用
----其他功能

--真正的加载，在C#端实现
local CS_LoadManager = CS.AppFacade.instance:GetLoadManager()

LoadManager = {
    --LoadPersisdentRes = LoadManager_LoadPersisdentRes,
    --LoadScene = LoadManager_LoadScene,
    --LoadUI = LoadManager_LoadUI,
    --LoadUI_Direct = LoadManager_LoadUI_Direct,
    --LoadCharacter = LoadManager_LoadCharacter,
    --LoadCar = LoadManager_LoadCar,
    --
    --LoadGameobject = LoadManager_LoadGameobject,
    --CopyGameobject = LoadManager_CopyGameobject,
    --DestroyGameobject = LoadManager_DestroyGameobject,
    --
    --IsProsessRunning = IsProsessRunning,
    --Cleanup = Cleanup,
}

--加载UI  不经过AssetBundle 流程
function LoadManager.LoadUI_Direct(bundleName, func)
    CS_LoadManager:LoadUI_Direct(bundleName, func)
end

--加载Texture  不经过AssetBundle 流程
function LoadManager.LoadTexture_Direct(bundleName, func)
    CS_LoadManager:LoadTexture_Direct(bundleName, func)
end

--加载Sprite  不经过AssetBundle 流程
function LoadManager.LoadSprite_Direct(bundleName, func)
    CS_LoadManager:LoadSprite_Direct(bundleName, func)
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