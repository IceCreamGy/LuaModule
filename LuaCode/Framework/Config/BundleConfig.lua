--储存 AssetBundle的路径等等
--这个最终是由 Unity工具生成的。
--所以是Config，而不是 Data

local BundleConfig = {
    UI = {
        Path = {
            ["Panel_Login"] = "Prefab/UI/LoginScene/Panel_Login",

            ["Panel_Loading"] = "Prefab/UI/LoadingScene/Panel_Loading",

            ["Panel_MainScene"] = "Prefab/UI/MainScene/Panel_MainScene",
            ["Panel_WindowOnLeft"] = "Prefab/UI/MainScene/Panel_WindowOnLeft",
            ["Panel_WindowOnBelow"] = "Prefab/UI/MainScene/Panel_WindowOnBelow",
            ["Panel_WindowOnUp"] = "Prefab/UI/MainScene/Panel_WindowOnUp",

            ["Panel_Shop"] = "Prefab/UI/MainScene/Shop/Panel_Shop",
            ["ImagePro_ShopSelectButtonItem"] = "Prefab/UI/MainScene/Shop/ImagePro_ShopSelectButtonItem",
            ["Panel_Shop_ZhanGui"] = "Prefab/UI/MainScene/Shop/Panel_Shop_ZhanGui",
            ["Panel_Shop_LingJian"] = "Prefab/UI/MainScene/Shop/Panel_Shop_LingJian",
            ["Panel_Shop_LingJianItem"] = "Prefab/UI/MainScene/Shop/Panel_Shop_LingJianItem",

            ["Panel_QianDao"] = "Prefab/UI/MainScene/QianDao/Panel_QianDao",

            ["Panel_BuJi"] = "Prefab/UI/MainScene/BuJi/Panel_BuJi",
            ["Panel_BuJiResult"] = "Prefab/UI/MainScene/BuJi/Panel_BuJiResult",

            ["Panel_BiSai"] = "Prefab/UI/MainScene/BiSai/Panel_BiSai",
            ["Panel_DuiZhanDaTing_Map"] = "Prefab/UI/MainScene/BiSai/Panel_DuiZhanDaTing_Map",
            ["Panel_TiaoZhan"] = "Prefab/UI/MainScene/TiaoZhan/Panel_TiaoZhan",
            ["Panel_JuQing"] = "Prefab/UI/MainScene/JuQing/Panel_JuQing",
        },
        Code = {
            ["Panel_Login"] = "ApplicationLayer/UI/LoginScene/Panel_Login",

            ["Panel_Loading"] = "ApplicationLayer/UI/LoadingScene/Panel_Loading",

            ["Panel_MainScene"] = "ApplicationLayer/UI/MainScene/Main/Panel_MainScene",
            ["Panel_WindowOnLeft"] = "ApplicationLayer/UI/MainScene/Main/Panel_WindowOnLeft",
            ["Panel_WindowOnBelow"] = "ApplicationLayer/UI/MainScene/Main/Panel_WindowOnBelow",
            ["Panel_WindowOnUp"] = "ApplicationLayer/UI/MainScene/Main/Panel_WindowOnUp",

            ["Panel_Shop"] = "ApplicationLayer/UI/MainScene/Shop/Panel_Shop",
            ["ImagePro_ShopSelectButtonItem"] = "ApplicationLayer/UI/MainScene/Shop/ImagePro_ShopSelectButtonItem",
            ["Panel_Shop_ZhanGui"] = "ApplicationLayer/UI/MainScene/Shop/Panel_Shop_ZhanGui",
            ["Panel_Shop_LingJian"] = "ApplicationLayer/UI/MainScene/Shop/Panel_Shop_LingJian",
            ["Panel_Shop_LingJianItem"] = "ApplicationLayer/UI/MainScene/Shop/Panel_Shop_LingJianItem",

            ["Panel_QianDao"] = "UI/MainScene/QianDao/Panel_QianDao",

            ["Panel_BuJi"] = "ApplicationLayer/UI/MainScene/BuJi/Panel_BuJi",
            ["Panel_BuJiResult"] = "ApplicationLayer/UI/MainScene/BuJi/Panel_BuJiResult",

            ["Panel_BiSai"] = "ApplicationLayer/UI/MainScene/BiSai/Panel_BiSai",
            ["Panel_DuiZhanDaTing_Map"] = "ApplicationLayer/UI/MainScene/BiSai/Panel_DuiZhanDaTing_Map",
            ["Panel_TiaoZhan"] = "ApplicationLayer/UI/MainScene/TiaoZhan/Panel_TiaoZhan",
            ["Panel_JuQing"] = "ApplicationLayer/UI/MainScene/JuQing/Panel_JuQing",
        },
    }
}

function BundleConfig.Get_UIAsset(name)
    return BundleConfig.UI.Path[name]
end
function BundleConfig.Get_UICode(name)
    return BundleConfig.UI.Code[name]
end
return BundleConfig