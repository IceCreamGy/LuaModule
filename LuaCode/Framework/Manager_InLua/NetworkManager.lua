--网络层从pb层获取解析、加密的数据进行发送
--网络消息中心，注册、移除、分发、发送

local util = require("Framework/Tools/util")

--消息表
local msg_register_table = {}
--注册的消息id
local register_id = 0

local function Dispatch(msg_ID, bytes )
    local msg_table = ProtobufManager.DeSerialize(msg_ID,bytes)
    if(msg_table ~= nil) then
        print(string.format("receive msg========= type: %s , name:%s , value: %s", msg_ID, MSG_TYPE[msg_ID] ,util.table_to_string(msg_table)))
        local funcs =  msg_register_table[msg_ID]
        if funcs ~= nil then

            for key, func in pairs(funcs) do
                func(msg_table)
            end
        end
    end
end

local function Send(msg_ID, msgTalbe)
    --根据协议type和table，解析成bytes
    local msg_bytes = ProtobufManager.Serialize(msg_ID,msgTalbe)
    if(msg_bytes~=nil) then
        NetworkManager_InCS.SendNetMsg(msg_ID,msg_bytes)
    end
end

local function Register(msg_ID, func)
    if msg_register_table[msg_ID] == nil then
        msg_register_table[msg_ID] = {}
    end
    local net_msg_register_id = register_id
    msg_register_table[msg_ID][net_msg_register_id] = func
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