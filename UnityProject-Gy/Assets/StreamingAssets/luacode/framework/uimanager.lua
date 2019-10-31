-- UI管理系统：
--打开 UI
--关闭 UI
--关闭所有 UI

local Stack = require("Framework/Tools/DataStructure/Stack")
--local LoadManager = require("Framework/CS_Interface/LoadManager")

UIManager = {}
local self = UIManager

local panel_stack = Stack.New()
local panel_dic = {}

--先去缓存中找，找不到调用InitPanel
--name 面板名字，args 参数，callBack 回调
function UIManager.OpenUI(panelPath, args, callBack)
    --local panelInstance = panel_dic[dlg_name]
    --未来会进行判断，分流程执行

	self.LoadUIPanel(panelPath, args, function(panel_instance)  --从磁盘加载
        self.SaveUI(panel_instance)     --缓存
        if(panel_instance~=nil) then
            callBack(panel_instance)    --触发回调
        end
    end)
end

function UIManager.CloseUI()
    print("close ui")
end

function UIManager.CLoseAllUI()
    print("closeAll ui")
end

--从AssetBundle加载面板  （先暂时模拟）
function UIManager.LoadUIPanel(panelPath, args, callBack)
    local prefix = string.match(panelPath, '.*/')
    local panelName = string.sub(panelPath, string.len(prefix) + 1)

    LoadManager.LoadUI_Direct(panelName, function(Panel, UiTable, CanvasGroup)
        print(Panel)
        local panel_instance = self.InitPanel(panelPath, Panel, UiTable, CanvasGroup, args)
        callBack(panel_instance)
    end)
end

--初始化面板逻辑
function UIManager.InitPanel(panelPath, Panel, UiTable, CanvasGroup, args)
    local panel_class = require(panelPath)

    local panel_instance = panel_class.New(panelPath, Panel, UiTable, CanvasGroup, args)
    return panel_instance
end

--保存到字典中
function UIManager.SaveUI(panel_instance)
    panel_dic[panel_instance:get_dlg_name()] = panel_instance
end

return UIManager