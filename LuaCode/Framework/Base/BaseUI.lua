--面板的基类

local eventmanager = require "Framework/EventManager"
local network = require "Framework/NetManager_InLua"
---@class Base_UI
local Base_UI = Class("Base_UI")

---@private
function Base_UI:ctor(arg_dlgname, arg_panel, arg_uitable, canvas_group, args)
    local prefix = string.match(arg_dlgname, '.*/')
    local panelName = string.sub(arg_dlgname, string.len(prefix) + 1)
    self.dlgname = panelName                  --dlg名字
    self.panel = arg_panel                      --ui面板- 加载出来的GameObject对象
    self.uitable = arg_uitable                  --收集的ui控件
    self.CG = canvas_group            --canvas group 控制显隐
    --self.dialog_config = arg_dialog_config      --dialog配置文件
    self.timer_table = {}                        --定时器函数列表
    self.lua_event_register_table = {}          --lua面板注册事件
    self.net_msg_register_table = {}            --网络层注册事件
    self.isclose = false                         --关闭状态
    self.panel_releasd = false                 --面板是否被销毁
    self.release_panel = function()
        --释放面板的实例方法，不定义在基类中，因为基类方法指向同一位置
        self.panel_releasd = true               --删除panel面板，取消相关gameobject的事件监听
        self:clear_res_and_register()
    end
    self:Init(args)
end

---初始化
function Base_UI:Init(args)
    if self.on_change_language then
        eventmanager.register_lua_event(Lua_Event.ChangeLanguage,
                function()
                    self:on_change_language()
                end)
    end

    if self.On_Init then
        self:On_Init(args)
    end
    self:Show()
end

--释放
function Base_UI:clear_res_and_register()
    if self.panel ~= nil then
        LoadManager.DestroyGameobject(self.panel)
    end
    self.panel = nil
    self.uitable = nil
    self.CG = nil
    self:clear_lua_event_register()
    self:clear_net_msg_register()
    self:remove_all_timer()
end

--UI 显示
function Base_UI:Show(args)
    self.isclose = false
    self:set_panel_visible()
    if self.On_Show then
        --子类写on_show
        self:On_Show(args)
    end
end

--UI 出栈
function Base_UI:Re_Show(args)
    self.isclose = false
    self:set_panel_visible()
    if self.On_Re_Show then
        --子类写on_re_show
        self:On_Re_Show(args)
    end
end

--UI 入栈被覆盖时调用
function Base_UI:Hide()
    self:set_panel_invisible()
    if self.On_Hide then
        --子类写on_hide
        self:On_Hide()
    end
end

--UI 销毁
function Base_UI:Close()
    self:Hide()
    if self.On_Close then
        --子类写on_hide
        self:On_Close()
    end
    self.isclose = true
end

--注册lua事件
function Base_UI:register_lua_event(eventType, func)
    local register_id = eventmanager.register_lua_event(eventType, func)
    self.lua_event_register_table[eventType] = register_id
end

--移除注册事件
function Base_UI:unregister_lua_event(eventType, register_id)
    eventmanager.unregister_lua_event(eventType, register_id)
end

function Base_UI:get_dlg_name()
    return self.dlgname
end

--判断资源是否被释放
function Base_UI:is_panel_released()
    return self.panel_releasd
end

--判断面板是否被关闭
function Base_UI:is_panel_close()
    return self.isclose
end

function Base_UI:set_panel_visible()
    self.CG.interactable = true
    self.CG.blocksRaycasts = true
end

function Base_UI:set_panel_invisible()
    self.CG.interactable = false
    self.CG.blocksRaycasts = false
end

function Base_UI:SetPriority()
    self.panel. transform:SetAsLastSibling()
end

return Base_UI