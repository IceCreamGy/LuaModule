--场景管理器

local function LoadScene(Name,EndAction)
    UIManager.CloseAllUI()
    UIManager.OpenUI("ApplicationLayer/UI/LoadingScene/Panel_Loading")
    LoadManager.LoadScene(Name,EndAction)
end

return {
    LoadScene = LoadScene
}