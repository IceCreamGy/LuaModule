-- 消息系统

--消息表   登出时重置
local event_register_table = {}
--注册的消息id
local register_id = 0

--注册消息
local function RegistEvent(eventType, func)
    if event_register_table[eventType] == nil then
        event_register_table[eventType] = {}
    end
    local event_register_id = register_id
    event_register_table[eventType][event_register_id] = func
    register_id = register_id + 1
    return event_register_id
end

--分发消息
local function DispachEvent(eventType, params)
    if event_register_table[eventType] ~= nil then
        for key, func in pairs(event_register_table[eventType]) do
            func(params)
        end
    end
end

--移除消息
local function RemoveEvent(eventType, event_register_id)
    if event_register_table[eventType] ~= nil then
        event_register_table[eventType][event_register_id] = nil
    end
end


local function RemoveAll()
    event_register_table = {}
    register_id = 0
end

return {
    RegistEvent = RegistEvent,
    DispachEvent=DispachEvent,
}
