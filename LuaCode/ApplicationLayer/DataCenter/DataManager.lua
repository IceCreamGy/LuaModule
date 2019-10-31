--初始化，加载到内存

local ActiveData= require("ApplicationLayer/DataCenter/ActiveData")		--活动中心
local ShopData= require("ApplicationLayer/DataCenter/ShopData")		--商店数据

--数据中心
local DataManager ={};
function DataManager.GetActiveData()
    return ActiveData
end

function DataManager.GetShopData()
    return ShopData
end

return DataManager;