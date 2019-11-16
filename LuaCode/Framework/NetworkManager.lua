--网络模块工具类
--序列化
--反序列化
--网络事件广播出去
--网络层从pb层获取解析、加密的数据进行发送
--网络消息中心，注册、移除、分发、发送

local pbmanager = require"Framework/ProtobufManager"

--消息表
local msg_register_table = {}
--注册的消息id
local register_id = 0

local function Dispatch(msgType , bytes )
    local msg_table = pbmanager.get_msg_table(msgType,bytes)
    if(msg_table ~= nil) then
        print(string.format("receive msg========= type: %s , name:%s , value: %s",msgType , MSG_TYPE[msgType] ,util.table_to_string(msg_table)))
        local funcs =  msg_register_table[msgType]
        if funcs ~= nil then

            for key, func in pairs(funcs) do
                func(msg_table)
            end
        end
    end
end

local function Send(msgType, msgTalbe)
    --根据协议type和table，解析成bytes
    local msg_bytes = pbmanager.get_msg_bytes(msgType,msgTalbe)
    if(msg_bytes~=nil) then
        NetworkManager.SendNetMsg(msgType,msg_bytes)
    end
end

local function Register(msgType, func)
    if msg_register_table[msgType] == nil then
        msg_register_table[msgType] = {}
    end
    local net_msg_register_id = register_id
    msg_register_table[msgType][net_msg_register_id] = func
    register_id = register_id + 1
    return net_msg_register_id
end

local function UnRegister(msgType, net_msg_register_id)
    if msg_register_table[msgType] ~= nil then
        msg_register_table[msgType][net_msg_register_id] = nil
    end
end

return{
    Dispatch = Dispatch,
    Register = Register,
    UnRegister = UnRegister,
    Send = Send
}