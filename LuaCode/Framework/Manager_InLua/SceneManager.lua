--场景管理器

local function LoadScene(Name,EndAction)
    UIManager.OpenOneUI("Panel_Loading")
    --要去清空对象池
    --要去释放资源
    LoadManager_InCS.LoadScene(Name,EndAction)
end

return {
    LoadScene = LoadScene
}