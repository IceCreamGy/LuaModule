--场景管理器

local function LoadScene(Name,EndAction)
    UIManager.CloseAllUI()
    UIManager.OpenUI("Panel_Loading")
    LoadManager.LoadScene(Name,EndAction)
end

return {
    LoadScene = LoadScene
}