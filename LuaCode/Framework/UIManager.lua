-- UI管理系统：
--ToDo：内存管理

local Stack = require("Framework/Tools/DataStructure/Stack")
local BundleConfig = require("Framework/Config/BundleConfig")

UIManager = {}
local self = UIManager

local panel_stack = Stack.New()
UIManager.panel_dic = {}

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
    local prefix = string.match(panelPath, '.*/')
    local panelName = string.sub(panelPath, string.len(prefix) + 1)
    local panel_instance = UIManager.panel_dic[panelName]
    if panel_instance then
        --有的话，重新显示
        if panel_instance:is_panel_released() == false then
            panel_instance:Show()
            self.Push_panel(panel_instance)
            return
        else
            --暂不考虑释放后
        end
    else
        --没有的话，从磁盘加载，实例化面板
        self.LoadUI(panelPath, args, function(panel_instance)
            self.SaveUI(panel_instance)
            self.Push_panel(panel_instance)
        end)
    end
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
function UIManager.CLoseAllUI()
    print("closeAll ui")
end

function UIManager.OpenPoPupUI(panelPath, args)
    --打开弹出式的UI 不经过栈
    local prefix = string.match(panelPath, '.*/')
    local panelName = string.sub(panelPath, string.len(prefix) + 1)
    local panel_instance = UIManager.panel_dic[panelName]
    if panel_instance then
        --有的话，重新显示
        if panel_instance:is_panel_released() == false then
            panel_instance:Show()
            panel_instance:SetPriority()
            return
        else
            --暂不考虑释放后
        end
    else
        --没有的话，从磁盘加载，实例化面板
        self. LoadUI(panelPath, args, function(panel_instance)
            self.SaveUI(panel_instance)
        end)
    end
end
function UIManager.OpenPoPupUIWithParent(panelPath, parent, args)
    local prefix = string.match(panelPath, '.*/')
    local panelName = string.sub(panelPath, string.len(prefix) + 1)
    local panel_instance = UIManager.panel_dic[panelName]
    if panel_instance then
        --有的话，重新显示
        if panel_instance:is_panel_released() == false then
            panel_instance:Show(args)
            panel_instance:SetPriority()
            return
        else
            --暂不考虑释放后
        end
    else
        --没有的话，从磁盘加载，实例化面板
        self. LoadUI_WithParent(panelPath, parent,args, function(panel_instance)
            self.SaveUI(panel_instance)
        end)
    end
end
function UIManager.ClosePoPupUI(panelPath, args)
    local panel_instance = panel_dic[panelPath]
    panel_instance:Close()
end

function UIManager.Push_panel(panel_instance)
    if not panel_stack:isEmpty() then
        local last_panel = panel_stack:top()
        last_panel:Hide()
    end
    panel_stack:push(panel_instance)
end

function UIManager.LoadUI(panelPath, args, callBack)
    --从硬盘加载面板
    local prefix = string.match(panelPath, '.*/')
    local panelName = string.sub(panelPath, string.len(prefix) + 1)
    local panelPathInUnity= BundleConfig.Get_UI(panelName)   --根据Panel名，对应资源加载的路径

    LoadManager.LoadUI(panelPathInUnity, function(Panel, UiTable, CanvasGroup)
        local panel_instance = self.InitPanel(panelPath, Panel, UiTable, CanvasGroup, args)
        callBack(panel_instance)
    end)
end
function UIManager.LoadUI_WithParent(panelPath, parent, args, callBack)
    --从硬盘加载面板
    local prefix = string.match(panelPath, '.*/')
    local panelName = string.sub(panelPath, string.len(prefix) + 1)
    local panelPathInUnity= BundleConfig.Get_UI(panelName)   --根据Panel名，对应资源加载的路径

    LoadManager.LoadUI_WithParent(panelPathInUnity,parent, function(Panel, UiTable, CanvasGroup)
        local panel_instance = self.InitPanel(panelPath, Panel, UiTable, CanvasGroup, args)
        callBack(panel_instance)
    end)
end

function UIManager.InitPanel(panelPath, Panel, UiTable, CanvasGroup, args)
    --初始化面板逻辑
    local panel_class = require(panelPath)

    local panel_instance = panel_class.New(panelPath, Panel, UiTable, CanvasGroup, args)
    return panel_instance
end
function UIManager.SaveUI(panel_instance)
    --保存到字典中
    UIManager.panel_dic[panel_instance:get_dlg_name()] = panel_instance
end

function UIManager.GetPanel(panelName)
    --返回指定面板控制器
    return UIManager.panel_dic[panelName]
end

return UIManager