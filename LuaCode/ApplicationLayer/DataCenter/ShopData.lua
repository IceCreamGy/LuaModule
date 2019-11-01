--商店的数据中心
ShopData = {}
ShopData.ButtonList = {
    {
        showOrder = 0, --展示顺序
        name = "推荐展柜", --按钮名字
        type="TuiJian",
        normalImage = "Shop/Button/corner_mark_black_normal", --常态图片
        selectImage = "Shop/Button/corner_mark_black_pressed", --按住后的图片
        TargetModel = "ApplicationLayer/UI/Shop/Panel_Shop_ZhanGui",         --对应的目标模块控制器
        TargetData="ZhanGui",
    },
     {
        showOrder = 1,
        name = "S车零件",
        type="ZhanShi",
        normalImage = "Shop/Button/corner_mark_black_normal",
        selectImage = "Shop/Button/corner_mark_black_pressed",
        TargetModel = "ApplicationLayer/UI/Shop/Panel_Shop_LingJian",
        TargetData="SLingJian",
    },
     {
        showOrder = 2,
        name = "A车零件",
        type="ZhanShi",
        normalImage = "Shop/Button/corner_mark_black_normal",
        selectImage = "Shop/Button/corner_mark_black_pressed",
        TargetModel = "ApplicationLayer/UI/Shop/Panel_Shop_LingJian",
        TargetData="ALingJian",
    },
    {
        showOrder = 3,
        name = "B车C车零件",
        type="ZhanShi",
        normalImage = "Shop/Button/corner_mark_black_normal",
        selectImage = "Shop/Button/corner_mark_black_pressed",
        TargetModel = "ApplicationLayer/UI/Shop/Panel_Shop_LingJian",
        TargetData="BCLingJian",
    },
     {
        showOrder = 4,
        name = "消耗品",
        type="ZhanShi",
        normalImage = "Shop/Button/corner_mark_black_normal",
        selectImage = "Shop/Button/corner_mark_black_pressed",
        TargetModel = "ApplicationLayer/UI/Shop/Panel_Shop_LingJian",
        TargetData="SLingJian",
    }
}

ShopData.ZhanGui={
    {
        showOrder = 0, --展示顺序
        name = "V16引擎",
        icon="Shop/LingJianS/carRefit_280101",
        moneyType="DianJuan",
        moneyCount="50000",
    },
    {
        showOrder = 1,
        name = "碳瓷制动器",
        icon="Shop/LingJianS/carRefit_280201",
        moneyType="DianJuan",
        moneyCount="16000",
    },
    {
        showOrder = 2, --展示顺序
        name = "半热熔胎",
        icon="Shop/LingJianS/carRefit_280301",
        moneyType="DianJuan",
        moneyCount="12000",
    },
    {
        showOrder = 3, --展示顺序
        name = "运动胎",
        icon="Shop/LingJianS/carRefit_280302",
        moneyType="DianJuan",
        moneyCount="7000",
    },
    {
        showOrder = 4, --展示顺序
        name = "全热熔胎",
        icon="Shop/LingJianS/carRefit_280303",
        moneyType="DianJuan",
        moneyCount="18000",
    },
    {
        showOrder = 5, --展示顺序
        name = "双重涡轮",
        icon="Shop/LingJianS/carRefit_280401",
        moneyType="DianJuan",
        moneyCount="32000",
    },
    {
        showOrder = 6, --展示顺序
        name = "可调尾翼",
        icon="Shop/LingJianS/carRefit_280501",
        moneyType="DianJuan",
        moneyCount="20000",
    },
    {
        showOrder = 7, --展示顺序
        name = "失速尾翼",
        icon="Shop/LingJianS/carRefit_280502",
        moneyType="DianJuan",
        moneyCount="23000",
    },
    {
        showOrder = 8, --展示顺序
        name = "扰流翼",
        icon="Shop/LingJianS/carRefit_280503",
        moneyType="DianJuan",
        moneyCount="17000",
    },
    {
        showOrder = 9, --展示顺序
        name = "合金排气",
        icon="Shop/LingJianS/carRefit_280601",
        moneyType="DianJuan",
        moneyCount="7500",
    },
}
ShopData.SLingJian={
    {
        showOrder = 0, --展示顺序
        name = "V16引擎",
        icon="Shop/LingJianS/carRefit_280101",
        moneyType="DianJuan",
        moneyCount="50000",
    },
    {
        showOrder = 1,
        name = "碳瓷制动器",
        icon="Shop/LingJianS/carRefit_280201",
        moneyType="DianJuan",
        moneyCount="16000",
    },
    {
        showOrder = 2, --展示顺序
        name = "半热熔胎",
        icon="Shop/LingJianS/carRefit_280301",
        moneyType="DianJuan",
        moneyCount="12000",
    },
    {
        showOrder = 3, --展示顺序
        name = "运动胎",
        icon="Shop/LingJianS/carRefit_280302",
        moneyType="DianJuan",
        moneyCount="7000",
    },
    {
        showOrder = 4, --展示顺序
        name = "全热熔胎",
        icon="Shop/LingJianS/carRefit_280303",
        moneyType="DianJuan",
        moneyCount="18000",
    },
    {
        showOrder = 5, --展示顺序
        name = "双重涡轮",
        icon="Shop/LingJianS/carRefit_280401",
        moneyType="DianJuan",
        moneyCount="32000",
    },
    {
        showOrder = 6, --展示顺序
        name = "可调尾翼",
        icon="Shop/LingJianS/carRefit_280501",
        moneyType="DianJuan",
        moneyCount="20000",
    },
    {
        showOrder = 7, --展示顺序
        name = "失速尾翼",
        icon="Shop/LingJianS/carRefit_280502",
        moneyType="DianJuan",
        moneyCount="23000",
    },
    {
        showOrder = 8, --展示顺序
        name = "扰流翼",
        icon="Shop/LingJianS/carRefit_280503",
        moneyType="DianJuan",
        moneyCount="17000",
    },
    {
        showOrder = 9, --展示顺序
        name = "合金排气",
        icon="Shop/LingJianS/carRefit_280601",
        moneyType="DianJuan",
        moneyCount="7500",
    },
}
ShopData.ALingJian={
    {
        showOrder = 0, --展示顺序
        name = "V16引擎",
        icon="Shop/LingJianA/carRefit_000101",
        moneyType="DianJuan",
        moneyCount="50000",
    },
    {
        showOrder = 1,
        name = "碳瓷制动器",
        icon="Shop/LingJianA/carRefit_000201",
        moneyType="DianJuan",
        moneyCount="16000",
    },
    {
        showOrder = 2, --展示顺序
        name = "半热熔胎",
        icon="Shop/LingJianA/carRefit_000301",
        moneyType="DianJuan",
        moneyCount="12000",
    },
    {
        showOrder = 3, --展示顺序
        name = "运动胎",
        icon="Shop/LingJianA/carRefit_000302",
        moneyType="DianJuan",
        moneyCount="7000",
    },
    {
        showOrder = 4, --展示顺序
        name = "全热熔胎",
        icon="Shop/LingJianA/carRefit_000303",
        moneyType="DianJuan",
        moneyCount="18000",
    },
    {
        showOrder = 5, --展示顺序
        name = "双重涡轮",
        icon="Shop/LingJianA/carRefit_000401",
        moneyType="DianJuan",
        moneyCount="32000",
    },
    {
        showOrder = 6, --展示顺序
        name = "可调尾翼",
        icon="Shop/LingJianA/carRefit_000501",
        moneyType="DianJuan",
        moneyCount="20000",
    },
    {
        showOrder = 7, --展示顺序
        name = "失速尾翼",
        icon="Shop/LingJianA/carRefit_000502",
        moneyType="DianJuan",
        moneyCount="23000",
    },
    {
        showOrder = 8, --展示顺序
        name = "扰流翼",
        icon="Shop/LingJianA/carRefit_000503",
        moneyType="DianJuan",
        moneyCount="17000",
    },
    {
        showOrder = 9, --展示顺序
        name = "合金排气",
        icon="Shop/LingJianA/carRefit_000601",
        moneyType="DianJuan",
        moneyCount="7500",
    },
}
ShopData.BCLingJian={
    {
        showOrder = 0, --展示顺序
        name = "V8引擎",
        icon="Shop/LingJianBC/refit_030101",
        moneyType="DianJuan",
        moneyCount="50000",
    },
    {
        showOrder = 1, --展示顺序
        name = "V8引擎",
        icon="Shop/LingJianBC/refit_030101",
        moneyType="DianJuan",
        moneyCount="50000",
    },
    {
        showOrder = 2, --展示顺序
        name = "水冷涡轮",
        icon="Shop/LingJianBC/refit_030401",
        moneyType="DianJuan",
        moneyCount="12000",
    },
    {
        showOrder = 3,
        name = "盘式制动",
        icon="Shop/LingJianBC/refit_030201",
        moneyType="DianJuan",
        moneyCount="16000",
    },
    {
        showOrder = 4, --展示顺序
        name = "水冷涡轮",
        icon="Shop/LingJianBC/refit_030401",
        moneyType="DianJuan",
        moneyCount="12000",
    },
    {
        showOrder = 5, --展示顺序
        name = "全热熔胎",
        icon="Shop/LingJianBC/refit_140301",
        moneyType="DianJuan",
        moneyCount="7000",
    },
    {
        showOrder = 6, --展示顺序
        name = "全热熔胎",
        icon="Shop/LingJianBC/refit_140301",
        moneyType="DianJuan",
        moneyCount="7000",
    },
    {
        showOrder = 7, --展示顺序
        name = "盘式制动",
        icon="Shop/LingJianBC/refit_230201",
        moneyType="DianJuan",
        moneyCount="18000",
    },
    {
        showOrder = 8, --展示顺序
        name = "V6引擎",
        icon="Shop/LingJianBC/refit_260101",
        moneyType="DianJuan",
        moneyCount="18000",
    },
    {
        showOrder = 9, --展示顺序
        name = "V6引擎",
        icon="Shop/LingJianBC/refit_260101",
        moneyType="DianJuan",
        moneyCount="18000",
    },
}
ShopData.XiaoHaoPin={
    {
        showOrder = 0, --展示顺序
        name = "V16引擎",
        icon="Shop/LingJianS/carRefit_280101",
        moneyType="DianJuan",
        moneyCount="50000",
    },
    {
        showOrder = 1,
        name = "碳瓷制动器",
        icon="Shop/LingJianS/carRefit_280201",
        moneyType="DianJuan",
        moneyCount="16000",
    },
    {
        showOrder = 2, --展示顺序
        name = "半热熔胎",
        icon="Shop/LingJianS/carRefit_280301",
        moneyType="DianJuan",
        moneyCount="12000",
    },
    {
        showOrder = 3, --展示顺序
        name = "运动胎",
        icon="Shop/LingJianS/carRefit_280302",
        moneyType="DianJuan",
        moneyCount="7000",
    },
    {
        showOrder = 4, --展示顺序
        name = "全热熔胎",
        icon="Shop/LingJianS/carRefit_280303",
        moneyType="DianJuan",
        moneyCount="18000",
    },
    {
        showOrder = 5, --展示顺序
        name = "双重涡轮",
        icon="Shop/LingJianS/carRefit_280401",
        moneyType="DianJuan",
        moneyCount="32000",
    },
    {
        showOrder = 6, --展示顺序
        name = "可调尾翼",
        icon="Shop/LingJianS/carRefit_280501",
        moneyType="DianJuan",
        moneyCount="20000",
    },
    {
        showOrder = 7, --展示顺序
        name = "失速尾翼",
        icon="Shop/LingJianS/carRefit_280502",
        moneyType="DianJuan",
        moneyCount="23000",
    },
    {
        showOrder = 8, --展示顺序
        name = "扰流翼",
        icon="Shop/LingJianS/carRefit_280503",
        moneyType="DianJuan",
        moneyCount="17000",
    },
    {
        showOrder = 9, --展示顺序
        name = "合金排气",
        icon="Shop/LingJianS/carRefit_280601",
        moneyType="DianJuan",
        moneyCount="7500",
    },
}

ShopData.MoneyIcon_DianQuan="Shop/Money/money_stamp_token"
ShopData.MoneyIcon_DianQuan="Shop/Money/money_gold_token"

function ShopData:GetData(name)
    return ShopData[name]
end

return ShopData