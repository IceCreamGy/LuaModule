--最终是由工具生成的。所以是Config，而不是 Data
--Normal
--Top
--Tips
--Mask

local BundleConfig = {
    UI = {
        ["Panel_Login"] = { ["UILayer"] = "Normal",
                            ["AssetPath"] = "Prefab/UI/LoginScene/Panel_Login",
                            ["CodePath"] = "ApplicationLayer/UI/LoginScene/Panel_Login", },
        ["Panel_Loading"] = { ["UILayer"] = "Normal",
                              ["AssetPath"] = "Prefab/UI/LoadingScene/Panel_Loading",
                              ["CodePath"] = "ApplicationLayer/UI/LoadingScene/Panel_Loading", },
        ["Panel_MainScene"] = { ["UILayer"] = "Normal",
                                ["AssetPath"] = "Prefab/UI/MainScene/Panel_MainScene",
                                ["CodePath"] = "ApplicationLayer/UI/MainScene/Main/Panel_MainScene", },
        ["Panel_WindowOnLeft"] = { ["UILayer"] = "Normal",
                                   ["AssetPath"] = "Prefab/UI/MainScene/Panel_WindowOnLeft",
                                   ["CodePath"] = "ApplicationLayer/UI/MainScene/Main/Panel_WindowOnLeft", },
        ["Panel_WindowOnBelow"] = { ["UILayer"] = "Normal",
                                    ["AssetPath"] = "Prefab/UI/MainScene/Panel_WindowOnBelow",
                                    ["CodePath"] = "ApplicationLayer/UI/MainScene/Main/Panel_WindowOnBelow", },
        ["Panel_WindowOnUp"] = { ["UILayer"] = "Top",
                                 ["AssetPath"] = "Prefab/UI/MainScene/Panel_WindowOnUp",
                                 ["CodePath"] = "ApplicationLayer/UI/MainScene/Main/Panel_WindowOnUp", },
        ["Panel_Shop"] = { ["UILayer"] = "Normal",
                           ["AssetPath"] = "Prefab/UI/MainScene/Shop/Panel_Shop",
                           ["CodePath"] = "ApplicationLayer/UI/MainScene/Shop/Panel_Shop", },
        ["ImagePro_ShopSelectButtonItem"] = { ["UILayer"] = "Normal",
                                              ["AssetPath"] = "Prefab/UI/MainScene/Shop/ImagePro_ShopSelectButtonItem",
                                              ["CodePath"] = "ApplicationLayer/UI/MainScene/Shop/ImagePro_ShopSelectButtonItem", },
        ["Panel_Shop_ZhanGui"] = { ["UILayer"] = "Normal",
                                   ["AssetPath"] = "Prefab/UI/MainScene/Shop/Panel_Shop_ZhanGui",
                                   ["CodePath"] = "ApplicationLayer/UI/MainScene/Shop/Panel_Shop_ZhanGui", },
        ["Panel_Shop_LingJian"] = { ["UILayer"] = "Normal",
                                    ["AssetPath"] = "Prefab/UI/MainScene/Shop/Panel_Shop_LingJian",
                                    ["CodePath"] = "ApplicationLayer/UI/MainScene/Shop/Panel_Shop_LingJian", },
        ["Panel_Shop_LingJianItem"] = { ["UILayer"] = "Normal",
                                        ["AssetPath"] = "Prefab/UI/MainScene/Shop/Panel_Shop_LingJianItem",
                                        ["CodePath"] = "ApplicationLayer/UI/MainScene/Shop/Panel_Shop_LingJianItem", },
        ["Panel_QianDao"] = { ["UILayer"] = "Tips",
                              ["AssetPath"] = "Prefab/UI/MainScene/QianDao/Panel_QianDao",
                              ["CodePath"] = "ApplicationLayer/UI/MainScene/QianDao/Panel_QianDao", },
        ["Panel_BuJi"] = { ["UILayer"] = "Normal",
                           ["AssetPath"] = "Prefab/UI/MainScene/BuJi/Panel_BuJi",
                           ["CodePath"] = "ApplicationLayer/UI/MainScene/BuJi/Panel_BuJi", },
        ["Panel_BuJiResult"] = { ["UILayer"] = "Normal",
                                 ["AssetPath"] = "Prefab/UI/MainScene/BuJi/Panel_BuJiResult",
                                 ["CodePath"] = "ApplicationLayer/UI/MainScene/BuJi/Panel_BuJiResult", },
        ["Panel_BiSai"] = { ["UILayer"] = "Normal",
                            ["AssetPath"] = "Prefab/UI/MainScene/BiSai/Panel_BiSai",
                            ["CodePath"] = "ApplicationLayer/UI/MainScene/BiSai/Panel_BiSai", },
        ["Panel_DuiZhanDaTing_Map"] = { ["UILayer"] = "Normal",
                                        ["AssetPath"] = "Prefab/UI/MainScene/BiSai/Panel_DuiZhanDaTing_Map",
                                        ["CodePath"] = "ApplicationLayer/UI/MainScene/BiSai/Panel_DuiZhanDaTing_Map", },
        ["Panel_TiaoZhan"] = { ["UILayer"] = "Normal",
                               ["AssetPath"] = "Prefab/UI/MainScene/TiaoZhan/Panel_TiaoZhan",
                               ["CodePath"] = "ApplicationLayer/UI/MainScene/TiaoZhan/Panel_TiaoZhan", },
        ["Panel_JuQing"] = { ["UILayer"] = "Normal",
                             ["AssetPath"] = "Prefab/UI/MainScene/JuQing/Panel_JuQing",
                             ["CodePath"] = "ApplicationLayer/UI/MainScene/JuQing/Panel_JuQing", },

    }
}

function BundleConfig.Get_UIAsset(name)
    return BundleConfig.UI[name]["AssetPath"]
end
function BundleConfig.Get_UICode(name)
    return BundleConfig.UI[name]["CodePath"]
end
function BundleConfig.Get_UILayer(name)
    return BundleConfig.UI[name]["UILayer"]
end
return BundleConfig