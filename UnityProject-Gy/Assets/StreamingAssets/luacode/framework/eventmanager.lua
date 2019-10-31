-- 消息系统
--AddListener
--Broadcast
--RemoveListener
--Cleanup

--消息表   登出时重置
local event_register_table = {}
--注册的消息id
local register_id = 0


--注册消息
local function register_lua_event(eventType,func)
	if event_register_table[eventType] == nil then
		event_register_table[eventType] = {}
	end
	local event_register_id = register_id
	event_register_table[eventType][event_register_id] = func
	register_id = register_id + 1
	return event_register_id
end

--移除消息
local function unregister_lua_event(eventType,event_register_id)
	if event_register_table[eventType] ~= nil then
		event_register_table[eventType][event_register_id] = nil
	end
end

--分发消息
local function dispach_lua_event(eventType , params )
	if event_register_table[eventType] ~= nil then
		for key, func in pairs(event_register_table[eventType]) do
			func(params)
		end
	end
end



local function remove_all_lua_event_register()
	event_register_table = {}
	register_id = 0
end

return{
	register_lua_event = register_lua_event,
	unregister_lua_event = unregister_lua_event,
	dispach_lua_event = dispach_lua_event,
	remove_all_lua_event_register = remove_all_lua_event_register,
}


--ToDo：去参考XluaMaskter 框架中一些设计（高远去执行）