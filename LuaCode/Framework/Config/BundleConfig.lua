--储存 AssetBundle的路径等等
--这个最终是由 Unity工具生成的。
--所以是Config，而不是 Data

local BundleConfig = {
    UI = {
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



        ["xxxxx"] = "UI/Shop",
        ["xxxxxx"] = "UI/Shop",
        ["xxxxxxx"] = "UI/Shop",
        ["xxxxxxxx"] = "UI/Shop",
        ["xxxxxxxxx"] = "UI/Shop",
    }
}

function BundleConfig.Get_UI(name)
    return BundleConfig.UI[name]
end

return BundleConfig