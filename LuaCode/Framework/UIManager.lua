-- UI管理系统：
--ToDo：内存管理

local Stack = require("Framework/Tools/DataStructure/Stack")

UIManager = {}

local panel_stack = Stack.New()
local panel_dic = {}

local function Push_panel(panel_instance)
    if not panel_stack:isEmpty() then
        local last_panel = panel_stack:top()
        last_panel:Hide()
    end
    panel_stack:push(panel_instance)
end
local function InitPanel(panelName, Panel, UiTable, CanvasGroup, args)
    --初始化面板逻辑
    local panelCodePath = BundleConfig.Get_UICode(panelName)
    local panel_class = require(panelCodePath)
    local panel_instance = panel_class.New(panelName, Panel, UiTable, CanvasGroup, args)
    return panel_instance
end
local function LoadUI(panelName, args, callBack, parent)
    --从硬盘加载面板
    local panelPathInUnity = BundleConfig.Get_UIAsset(panelName)
    local callbackFromUnity = function(Panel, UiTable, CanvasGroup)
        local panel_instance = InitPanel(panelName, Panel, UiTable, CanvasGroup, args)
        callBack(panel_instance)
    end
    local layer = BundleConfig.Get_UILayer(panelName)
    LoadManager_InCS.LoadUI(layer, panelPathInUnity, callbackFromUnity, parent)
end
local function SaveUI(panel_instance)
    panel_dic[panel_instance:get_dlg_name()] = panel_instance
end

function UIManager.OpenUI(panelPath, args)
    --打开UI 经过栈
    if not panel_stack:isEmpty() then
        --如果最上面就是目标UI，不做处理。
        local panel_script = panel_stack:top()
        if panel_script:get_dlg_name() == dlg_name then
            return
        end
    end
    --/////////////////
    local panel_instance = panel_dic[panelPath]
    if panel_instance then
        --有的话，重新显示
        if panel_instance:is_panel_released() == false then
            panel_instance:Show()
            Push_panel(panel_instance)
            return
        else
            --暂不考虑释放后
        end
    else
        --没有的话，从磁盘加载，实例化面板
        LoadUI(panelPath, args, function(panel_instance)
            SaveUI(panel_instance)
            Push_panel(panel_instance)
        end)
    end
end
function UIManager.OpenPoPupUI(panelName, args, parent)
    local panel_instance = panel_dic[panelName]
    if panel_instance then
        if panel_instance:is_panel_released() == false then
            panel_instance:Show(args)
            panel_instance:SetPriority()
            return
        else
            --暂不考虑释放后
        end
    else
        --没有的话，从磁盘加载，实例化面板
        LoadUI( panelName, args, function(panel_instance)
            SaveUI(panel_instance)
        end, parent)
    end
end
function UIManager.OpenOneUI(panelName, args)
    UIManager.CloseAllUI()
    UIManager.OpenUI(panelName, args)
end
function UIManager.CloseUI()
    if not panel_stack:isEmpty() then
        --第一层元素，执行关闭流程
        local top_panel = panel_stack:pop()
        top_panel:Close()
    end
    --/////////////////
    if not panel_stack:isEmpty() then
        --第二层元素，执行恢复流程
        local top_panel = panel_stack:top()
        if top_panel:is_panel_released() == false then
            top_panel:Re_Show()
        else
            --暂不考虑释放后
        end
    end
end
function UIManager.CloseAllUI()
    --暂时粗糙一点
    for i, v in pairs(panel_dic) do
        v:Close()
    end
end
function UIManager.CloseTarget(panelName)
    panel_dic[panelName]:Close()
end

function UIManager.GetPanel(panelName)
    --返回指定面板控制器
    return panel_dic[panelName]
end

return UIManager