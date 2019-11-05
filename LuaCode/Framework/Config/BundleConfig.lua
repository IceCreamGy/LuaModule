--储存 AssetBundle的路径等等
--这个最终是由 Unity工具生成的。
--所以是Config，而不是 Data

local BundleConfig = {
    UI = {
        ["Panel_MainScene"] = "UI/Panel_MainScene",
        ["Panel_Shop"] = "UI/Shop/Prefab/Panel_Shop",
        ["Panel_Shop_LingJian"] = "UI/Shop/Prefab/Panel_Shop_LingJian",
        ["Panel_Shop_LingJianItem"] = "UI/Shop/Prefab/Panel_Shop_LingJianItem",
        ["Panel_Shop_ZhanGui"] = "UI/Shop/Prefab/Panel_Shop_ZhanGui",
        ["ImagePro_ShopSelectButtonItem"] = "UI/Shop/Prefab/ImagePro_ShopSelectButtonItem",
        ["Panel_Shop_ZhanGui"] = "UI/Shop/Prefab/Panel_Shop_ZhanGui",
        ["Panel_Shop_LingJian"] = "UI/Shop/Prefab/Panel_Shop_LingJian",
        ["Panel_QianDao"] = "UI/QianDao/Panel_QianDao",
        ["Panel_BuJi"] = "UI/BuJi/Panel_BuJi",
        ["Panel_BuJiResult"] = "UI/BuJi/Panel_BuJiResult",
        ["Panel_BiSai"] = "UI/BiSai/Panel_BiSai",
        ["Panel_DuiZhanDaTing_Map"] = "UI/BiSai/Panel_DuiZhanDaTing_Map",
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