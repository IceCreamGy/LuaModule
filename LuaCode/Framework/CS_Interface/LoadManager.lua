--从Unity中加载资源、对象

--真正的加载，在C#端实现
local CS_LoadManager = CS.AppFacade.instance:GetLoadManager()

--加载UI
local function LoadUI(layer, bundleName, func, parent)
    CS_LoadManager:LoadUI(layer, bundleName, func, parent)
end

--复制UI，并设置父物体
local function CopyUI_WithParent(gameobject, parent, func)
    return CS_LoadManager:CopyUI_WithParent(gameobject, parent, func)
end

--加载Texture
local function LoadTexture(bundleName, func)
    CS_LoadManager:LoadTexture(bundleName, func)
end

--加载Sprite
local function LoadSprite(bundleName, func)
    CS_LoadManager:LoadSprite(bundleName, func)
end

--加载GameObject
local function LoadGameObject(bundleName)
    return CS_LoadManager:LoadGameObject(bundleName)
end

--复制GameObject
local function CopyGameobject(bundleName)
    return CS_LoadManager:CopyGameobject(bundleName)
end

local function LoadScene(SceneName, EndAction)
    CS_LoadManager:LoadScene(SceneName, EndAction)
end

return {
    LoadUI = LoadUI,
    CopyUI_WithParent = CopyUI_WithParent,
    LoadTexture = LoadTexture,
    LoadSprite = LoadSprite,
    LoadGameObject = LoadGameObject,
    CopyGameobject = CopyGameobject,
    LoadScene = LoadScene,
}