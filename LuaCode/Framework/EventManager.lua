-- 消息系统

local EventManager={}

--消息表   登出时重置
local event_register_table = {}
--注册的消息id
local register_id = 0

--注册消息
 function EventManager.AddEvent(eventType,func)
	if event_register_table[eventType] == nil then
		event_register_table[eventType] = {}
	end
	local event_register_id = register_id
	event_register_table[eventType][event_register_id] = func
	register_id = register_id + 1
	return event_register_id
end

--移除消息
 function EventManager.RemoveEvent(eventType,event_register_id)
	if event_register_table[eventType] ~= nil then
		event_register_table[eventType][event_register_id] = nil
	end
end

--分发消息
 function EventManager.DispachEvent(eventType , params )
	if event_register_table[eventType] ~= nil then
		for key, func in pairs(event_register_table[eventType]) do
			func(params)
		end
	end
end

 function EventManager.RemoveAll()
	event_register_table = {}
	register_id = 0
end

return EventManager
