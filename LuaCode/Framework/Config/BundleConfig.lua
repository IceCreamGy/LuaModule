--储存 AssetBundle的路径等等
--这个最终是由 Unity工具生成的。
--所以是Config，而不是 Data

local BundleConfig = {
    UI = {
        Path = {
            ["Panel_Login"] = "UI/LoginScene/Panel_Login",

            ["Panel_Loading"] = "UI/LoadingScene/Panel_Loading",

            ["Panel_MainScene"] = "UI/MainScene/Panel_MainScene",
            ["Panel_WindowOnLeft"] = "UI/MainScene/Panel_WindowOnLeft",
            ["Panel_WindowOnBelow"] = "UI/MainScene/Panel_WindowOnBelow",
            ["Panel_WindowOnUp"] = "UI/MainScene/Panel_WindowOnUp",

            ["Panel_Shop"] = "UI/MainScene/Shop/Panel_Shop",
            ["ImagePro_ShopSelectButtonItem"] = "UI/MainScene/Shop/ImagePro_ShopSelectButtonItem",
            ["Panel_Shop_ZhanGui"] = "UI/MainScene/Shop/Panel_Shop_ZhanGui",
            ["Panel_Shop_LingJian"] = "UI/MainScene/Shop/Panel_Shop_LingJian",
            ["Panel_Shop_LingJianItem"] = "UI/MainScene/Shop/Panel_Shop_LingJianItem",

            ["Panel_QianDao"] = "UI/MainScene/QianDao/Panel_QianDao",

            ["Panel_BuJi"] = "UI/MainScene/BuJi/Panel_BuJi",
            ["Panel_BuJiResult"] = "UI/MainScene/BuJi/Panel_BuJiResult",

            ["Panel_BiSai"] = "UI/MainScene/BiSai/Panel_BiSai",
            ["Panel_DuiZhanDaTing_Map"] = "UI/MainScene/BiSai/Panel_DuiZhanDaTing_Map",
            ["Panel_TiaoZhan"] = "UI/MainScene/TiaoZhan/Panel_TiaoZhan",
            ["Panel_JuQing"] = "UI/MainScene/JuQing/Panel_JuQing",
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